extends Node3D

@onready var camera : Camera3D = %"Player Camera"
@onready var cup : Node3D = %"Player Cup"
@onready var cup_pos : Vector3 = cup.global_position
@onready var cup_bounds : MeshInstance3D = %"Cup Bounds"
@onready var cup_bounds_qm : QuadMesh = cup_bounds.mesh
var boundL : float
var boundR : float
var boundT : float
var boundB : float

var can_hold : bool = true
var is_holding : bool = false
var is_shaking : bool = false

@export_group("Cup Parameters")
@export var shake_height : float = 0.15
@export var shake_speed : float = 25
@export var depth_offset : float = 7.0
var time_passed : float = 0.0


func _ready() -> void:
	var w = cup_bounds_qm.size.x / 2.0
	var h = cup_bounds_qm.size.y / 2.0
	
	boundL = cup_bounds.global_position.x - w
	boundR = cup_bounds.global_position.x + w
	boundT = cup_bounds.global_position.y + h
	boundB = cup_bounds.global_position.y - h


func _process(delta: float) -> void:
	if not can_hold:
		is_holding = false
		is_shaking = false
	if is_holding:
		follow_mouse()
	if is_shaking:
		shake_cup(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and can_hold:
		is_holding = true
	elif event.is_action_released("LMB") and can_hold:
		is_holding = false
		cup.global_position = cup_pos
	
	if is_holding and event.is_action_pressed("RMB"):
		is_shaking = true
	elif (not is_holding and is_shaking) or event.is_action_released("RMB") and can_hold:
		is_shaking = false
		fukcing_roll_hellllll_yeah()

#draws a ray from the camera to the mouse position
#defines a plane at an offset facing toward the camera
#places the cup at the point where the ray and the plane intersect
func follow_mouse() -> void:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_start : Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_direction : Vector3 = camera.project_ray_normal(mouse_pos)
	
	var plane := Plane(Vector3.FORWARD, global_position.z - depth_offset)
	var intersection : Vector3 = plane.intersects_ray(ray_start, ray_direction)
	
	if intersection:
		cup.global_position = Vector3(clamp(intersection.x, boundL, boundR), clamp(intersection.y, boundB, boundT), intersection.z)

func shake_cup(delta: float) -> void:
	time_passed += delta
	cup.global_position.y = cup.global_position.y + sin(time_passed * shake_speed) * shake_height

func fukcing_roll_hellllll_yeah() -> void:
	can_hold = false
	cup.can_play_sound = false
	var tween := get_tree().create_tween()
	await tween.tween_property(cup, "global_position", Vector3(cup.global_position.x, cup.global_position.y + 5.0, cup.global_position.z), 0.25).finished
	
	tween.kill()
	tween = get_tree().create_tween()
	
	cup.global_position = %Playmat.cup_placer.global_position + Vector3(0,5,0)
	cup.global_rotation.z += deg_to_rad(180)
	
	await tween.tween_property(cup, "global_position", %Playmat.cup_placer.global_position + Vector3(0,cup.get_node("%CollisionShape3D").shape.size.y,0), 0.25).finished
	
	await get_tree().create_timer(1.0).timeout
	
	tween.kill()
	tween = get_tree().create_tween()
	
	%"Dice Spawner".spawn_objects(5)
	for die in %"Dice Spawner".get_children():
		die.reparent(%"Player Dice")
	
	tween.tween_property(cup, "global_position", Vector3(cup.global_position.x, cup.global_position.y + 5.0, cup.global_position.z), 0.25)
	
	await get_tree().create_timer(1.0).timeout
	
	cup.queue_free()
	
	place_dice()
	

func place_dice() -> void:
	for die in %"Player Dice".get_children():
		while not die.sleeping:
			await get_tree().create_timer(0.5).timeout
			continue
		var slot_name : String = die.name
		die.global_position = %Playmat.slot_dict[slot_name].global_position

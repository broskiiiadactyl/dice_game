extends Node3D

#This is a dice spawner
#Spawns dice on command

@export_group("Spawn Parameters")
@onready var spawn_scene: Node3D = %"Player Dice"
@export var use_random_rotation := false
@export var rotation_range := Vector3(360,360,360)
@export var spawn_timer := 0.0

@export_group("Dice Placement")
@export var radius : float = 0.1

func _ready() -> void:
	#spawn_objects(5)
	pass

func spawn_objects() -> void:
	var spawn_count : int = %PublicInformation.handsize_dict["player"]
	
	if spawn_scene == null:
		push_warning("No scene to spawn. Assign a scene.")
		return
	
	for i in range(spawn_count):
		var instance := spawn_scene.get_children()[i]
		
		var pos = place_dice(global_position, i - 1, spawn_count)
		
		var rot_x := rotation_range.x
		var rot_y := rotation_range.y
		var rot_z := rotation_range.z
		
		var rot = global_rotation
		
		if use_random_rotation:
			rot += Vector3(
				randf_range(-rot_x, rot_x),
				randf_range(-rot_y, rot_y),
				randf_range(-rot_z, rot_z)
			)
			
		instance.global_position = pos
		instance.global_rotation = rot
		instance.visible = true
		instance.sleeping = true

func place_dice(center: Vector3, dice: int, spawn_count: int) -> Vector3:
	
	var angle : float = ((2 * PI) / (spawn_count)) * dice
	var point = Vector2(center.x, center.z) + Vector2(cos(angle), sin(angle)) * radius
	return Vector3(point.x, center.y, point.y)

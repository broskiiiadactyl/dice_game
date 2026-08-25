extends Node3D

#This is a dice spawner
#Spawns dice on command

@export_group("Spawn Parameters")
@export var spawn_scene: PackedScene = load("res://Assets/Dice/Scenes/player_die.tscn")
@export var use_random_rotation := false
@export var rotation_range := Vector3(360,360,360)
@export var spawn_timer := 0.0

@export_group("Dice Placement")
@export var radius : float = 0.1

func _ready() -> void:
	spawn_objects(5)

func spawn_objects(spawn_count: int) -> void:
	if spawn_scene == null:
		push_warning("No scene to spawn. Assign a scene.")
		return
	
	for i in range(spawn_count):
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
			
		if spawn_timer > 0.0:
			await wait(spawn_timer)
			
		var instance := spawn_scene.instantiate()
		add_child(instance)
		instance.global_position = pos
		instance.global_rotation = rot
		instance.name = str("d", i + 1)
		instance.owner = self
		instance.unique_name_in_owner = true

func place_dice(center: Vector3, dice: int, spawn_count: int) -> Vector3:
	
	var angle : float = ((2 * PI) / (spawn_count)) * dice
	var point = Vector2(center.x, center.z) + Vector2(cos(angle), sin(angle)) * radius
	return Vector3(point.x, center.y, point.y)


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

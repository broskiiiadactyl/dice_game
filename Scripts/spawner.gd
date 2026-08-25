extends Node3D

#This is a general spawner
#Spawns objects on load
#Add the scene of whatever you want to spawn in the inspector

@export_group("Spawn Parameters")
@export var spawn_scene: PackedScene
@export var spawn_count := 5
#@export var use_random_offset := false
#@export var spawn_range := Vector3(0,0,0)
@export var use_random_rotation := false
@export var rotation_range := Vector3(0,0,0)
@export var spawn_timer := 0.0

@export_group("Dice Placement")
@export var radius : float = 0.1

func _ready() -> void:
	spawn_objects()

func spawn_objects() -> void:
	if spawn_scene == null:
		push_warning("No scene to spawn. Assign a scene.")
		return
	
	for i in range(spawn_count):
		#var x := spawn_range.x
		#var y := spawn_range.y
		#var z := spawn_range.z
		#
		#var pos = global_transform.origin
		#if use_random_offset:
			#pos += Vector3(
				#randf_range(-x, x),
				#randf_range(-y, y),
				#randf_range(-z, z)
			#)
		#var pos = global_position
		#if i == 1:
			#
		var pos = place_dice(global_position, i)
		
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
		#print(instance.name, " spawned at ", pos)
		add_child(instance)
		instance.global_position = pos
		instance.global_rotation = rot

func place_dice(center: Vector3, dice: int) -> Vector3:
	
	var angle : float = ((2 * PI) / (spawn_count - 1)) * (dice - 1)
	var point = Vector2(center.x, center.z) + Vector2(cos(angle), sin(angle)) * radius
	return Vector3(point.x, center.y, point.y)


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

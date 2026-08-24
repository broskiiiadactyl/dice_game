extends Node3D

@onready var camera : Camera3D = $Camera3D
@onready var cup : Node3D = %"Player Cup"
var is_holding : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_start : Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_direction : Vector3 = camera.project_ray_normal(mouse_pos)
	
	var plane := Plane(Vector3.FORWARD, global_position.z - 7)
	var intersection : Vector3 = plane.intersects_ray(ray_start, ray_direction)
	
	if intersection:
		cup.global_position = intersection

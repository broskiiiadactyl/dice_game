extends Node3D

@export var float_height := 0.1
@export var float_speed := 1.0
@export var rotation_speed := 1.0

var start_height := 0.0
var time_passed := 0.0

func _ready() -> void:
	start_height = global_position.y

func _process(delta: float) -> void:
	# Floating
	time_passed += delta
	global_position.y = start_height + sin(time_passed * float_speed) * float_height
	
	# Spinning
	#rotation.y += rotation_speed * delta

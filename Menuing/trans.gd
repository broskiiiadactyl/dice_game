extends Control

@onready var cover : ColorRect = %Cover

@onready var audio : AudioStreamPlayer3D = %AudioStreamPlayer3D

@export_file("*.tscn") var target_scene_path : String = "res://Main.tscn"

@onready var progress_bar : ProgressBar = %ProgressBar
var progress : Array

func _ready() -> void:
	var error = ResourceLoader.load_threaded_request(target_scene_path)
	if error != OK:
		push_error("Error loading scene ", target_scene_path, ": ", error)

func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	

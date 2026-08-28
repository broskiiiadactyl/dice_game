extends CanvasLayer

@onready var cover : ColorRect = %Cover

@onready var audio : AudioStreamPlayer3D = %AudioStreamPlayer3D

var target_scene_path

@onready var progress_bar : ProgressBar = %ProgressBar
var progress : Array
var loading : bool = false

func _process(_delta: float) -> void:
	if loading:
		var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				progress_bar.value = progress[0] * 100
			ResourceLoader.THREAD_LOAD_LOADED:
				var loaded_resource = ResourceLoader.load_threaded_get(target_scene_path)
				get_tree().change_scene_to_packed(loaded_resource)
				self.visible = false
				loading = false
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("Scene ", target_scene_path," failed to load! Status: ", status)
				set_process(false)
			_:
				push_error("This shouldn't happen! Something went wrong with ResourceLoader! Status: ", status)

func load_scene(target : String = "res://Main.tscn") -> void:
	self.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	loading = true
	target_scene_path = target
	var error = ResourceLoader.load_threaded_request(target_scene_path)
	if error != OK:
		push_error("Error loading scene ", target, ": ", error)

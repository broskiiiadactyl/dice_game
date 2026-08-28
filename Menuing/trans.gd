extends CanvasLayer

@onready var cover : ColorRect = %Cover

@onready var audio : AudioStreamPlayer3D = %AudioStreamPlayer3D

var target_scene_path
var loaded_resource

@onready var progress_bar : ProgressBar = %ProgressBar
@onready var timer : Timer = %"Progress Check"
@onready var load2 : RichTextLabel = %Load2
var progress : Array
var loading : bool = false

func _ready() -> void:
	Globals.main_loaded.connect(turn_off)

func _process(_delta: float) -> void:
	pass

func load_scene(target : String = "res://Main.tscn") -> void:
	#self.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	loading = true
	target_scene_path = target
	var error = ResourceLoader.load_threaded_request(target_scene_path)
	if error != OK:
		push_error("Error loading scene ", target, ": ", error)
	timer.start()

func start_scene() -> void:
	self.visible = true
	await get_tree().create_timer(1.0).timeout
	while not loaded_resource:
		await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(loaded_resource)
	load2.visible = true
	%AnimatedSprite2D.play("default")
	
func turn_off() -> void:
	self.visible = false

func _on_progress_check_timeout() -> void:
	if loading:
		var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				progress_bar.value = progress[0] * 100
			ResourceLoader.THREAD_LOAD_LOADED:
				progress_bar.value = progress[0] * 100
				loaded_resource = ResourceLoader.load_threaded_get(target_scene_path)
				loading = false
				timer.stop()
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("Scene ", target_scene_path," failed to load! Status: ", status)
				set_process(false)
				timer.stop()
			_:
				push_error("This shouldn't happen! Something went wrong with ResourceLoader! Status: ", status)
				timer.stop()

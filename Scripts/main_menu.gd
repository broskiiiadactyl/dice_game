extends Control

@onready var ui : Control = %UI
@onready var main : Control = %Main
@onready var opt : Control = %Options
@onready var tut : Control = %Tutorial
@onready var start : Control = %Start

@onready var cam : Camera3D = %Camera3D
var main_cam_pos := Vector3(17.938, 4.762, -38.36)
var main_cam_rot := -18.8
var other_cam_pos := Vector3(37.966, 4.762, -24.32)
var other_cam_rot := -48.3

@onready var master_bus : int = AudioServer.get_bus_index("Master")
@onready var volume : HSlider = %volume


func _ready() -> void:
	volume.value = AudioServer.get_bus_volume_linear(master_bus)
	if start.visible:
		Trans.load_scene()
		for child in %Bar1_2_Finalbase.get_children():
			if child.is_in_group("visible"):
				continue
			else:
				child.visible = false

func _on_options_pressed() -> void:
	main.visible = false
	await move_camera(1)
	opt.visible = true

func _on_tutorial_pressed() -> void:
	main.visible = false
	await move_camera(1)
	tut.visible = true

func _on_back_pressed() -> void:
	opt.visible = false
	tut.visible = false
	await move_camera(0)
	main.visible = true

func move_camera(out: bool) -> bool:
	var tween = get_tree().create_tween()
	if out:
		tween.parallel().tween_property(cam, "global_position", other_cam_pos, 0.25)
		tween.tween_property(cam, "global_rotation.y", deg_to_rad(other_cam_rot), 0.25)
	else:
		tween.parallel().tween_property(cam, "global_position", main_cam_pos, 0.25)
		tween.tween_property(cam, "global_rotation.y", deg_to_rad(main_cam_rot), 0.25)
	
	await tween.finished
	tween.kill()

	return true

func _on_start_pressed() -> void:
	Trans.start_scene()

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_resume_pressed() -> void:
	self.visible = false
	Globals.unpause.emit()

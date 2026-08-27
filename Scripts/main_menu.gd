extends Control

@onready var ui : Control = %UI
@onready var main : Control = %Main
@onready var opt : Control = %Options
@onready var tut : Control = %Tutorial

@onready var cam : Camera3D = %Camera3D
var main_cam_pos := Vector3(17.938, 4.762, -38.36)
var main_cam_rot := -18.8
var other_cam_pos := Vector3(37.966, 4.762, -24.32)
var other_cam_rot := -48.3

func _ready() -> void:
	for child in %Bar1_2_Finalbase.get_children():
		if child.is_in_group("visible"):
			continue
		else:
			child.visible = false

func _on_options_pressed() -> void:
	main.visible = false
	opt.visible = true
	move_camera(1)

func _on_tutorial_pressed() -> void:
	main.visible = false
	tut.visible = true
	move_camera(1)

func _on_back_pressed() -> void:
	main.visible = true
	opt.visible = false
	tut.visible = false
	move_camera(0)

func move_camera(out: bool) -> bool:
	var tween = get_tree().create_tween()
	if out:
		tween.parallel().tween_property(cam, "global_position", other_cam_pos, 0.25)
		tween.tween_property(cam, "global_rotation.y", deg_to_rad(other_cam_rot), 0.25)
		#cam.global_position = other_cam_pos
		#cam.global_rotation = other_cam_rot
	else:
		cam.global_position = main_cam_pos
		cam.global_rotation.y = deg_to_rad(main_cam_rot)

	return true

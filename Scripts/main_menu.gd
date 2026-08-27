extends Control

@onready var ui : Control = %UI
@onready var main : Control = %Main
@onready var opt : Control = %Options
@onready var tut : Control = %Tutorial


func _on_options_pressed() -> void:
	main.visible = false
	opt.visible = true


func _on_tutorial_pressed() -> void:
	main.visible = false
	tut.visible = true


func _on_back_pressed() -> void:
	main.visible = true
	opt.visible = false
	tut.visible = false

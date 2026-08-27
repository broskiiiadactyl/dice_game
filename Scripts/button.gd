extends Node3D

@onready var button : MeshInstance3D = %"press button"
@onready var label : Control = %Label
@onready var anim_player : AnimationPlayer = %AnimationPlayer

var can_press : bool = false
var mouse_over : bool = false

@onready var sounds : AudioStreamPlayer3D = %sounds
@onready var select_1 : AudioStream = load("res://Assets/Sounds/select_1.wav")
@onready var select_2 : AudioStream = load("res://Assets/Sounds/select_2.wav")

func set_text(text: String) -> void:
	label.text = text

func set_color(type: String) -> void:
	match type:
		"CALL":
			can_press = true
			button.get_active_material(0).set_shader_parameter("hologram_color", Color("d04c6aff"))
			button.get_active_material(0).set_shader_parameter("glitch_strength", 0.3)
			button.get_active_material(0).set_shader_parameter("glow_intensity", 0.5)
		"BET":
			can_press = true
			button.get_active_material(0).set_shader_parameter("hologram_color", Color("7cc43cff"))
			button.get_active_material(0).set_shader_parameter("glitch_strength", 0.3)
			button.get_active_material(0).set_shader_parameter("glow_intensity", 0.5)
		"INACTIVE":
			can_press = false
			button.get_active_material(0).set_shader_parameter("hologram_color", Color("76736dff"))
			button.get_active_material(0).set_shader_parameter("glitch_strength", 0.0)
			button.get_active_material(0).set_shader_parameter("glow_intensity", 0.0)


func _on_button_area_mouse_entered() -> void:
	mouse_over = true

func _on_button_area_mouse_exited() -> void:
	mouse_over = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and mouse_over and can_press:
		press_button(label.text)

func press_button(type: String) -> void:
	match type:
		"CALL":
			sounds.stream = select_2
			sounds.play()
		"BET":
			sounds.stream = select_1
			sounds.play()
	anim_player.play("Press")
	await anim_player.animation_finished
	Globals.playmat_button_pressed.emit(type)
	pass

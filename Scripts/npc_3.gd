extends Node3D

var expressions : Dictionary = {
	"Angry" : load("res://Assets/Characters/npc3/faces/Vicki_Angry_Expr.png"),
	"Thinky" : load("res://Assets/Characters/npc3/faces/Vicki_Thinky_Expr.png"),
	"Talk" : load("res://Assets/Characters/npc3/faces/Vicki_Talk_Expr.png"),
	"Surprise" : load("res://Assets/Characters/npc3/faces/Vicki_Surprise_Expr.png"),
	"Evil" : load("res://Assets/Characters/npc3/faces/Vicki_Nyeheh_Expr.png"),
	"Neutral" : load("res://Assets/Characters/npc3/faces/Vicki_Neutral_Expr.png")
}

@onready var player : AnimationPlayer = %AnimationPlayer
@onready var head_material : Material = %Head_003.get_active_material(0)

func _ready() -> void:
	expression_test()
	animation_test()

func expression_test() -> void:
	while true:
		for face in expressions:
			print(face)
			change_expression(face)
			await get_tree().create_timer(2.0).timeout

func animation_test() -> void:
	while true:
		for anim in player.get_animation_list():
			player.play(anim)
			await player.animation_finished

func change_expression(expression: String = "Neutral") ->void:
	print(head_material.emission_texture, " ", expressions[expression])
	head_material.emission_texture = expressions[expression]

func play_animation(anim: String = "Idle") -> void:
	if player.has_animation(anim):
		player.play(anim)
	else:
		push_error("Invalid animation set to ", name, ": ", anim)

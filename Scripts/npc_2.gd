extends Node3D

var expressions : Dictionary = {
	"Angry" : load("res://Assets/Characters/npc2/faces/Bara_Angy_Expr.png"),
	"Sad" : load("res://Assets/Characters/npc2/faces/Bara_Sad_Expr.png"),
	"Surprise" : load("res://Assets/Characters/npc2/faces/Bara_Surprise_Expr.png"),
	"Neutral" : load("res://Assets/Characters/npc2/faces/Bara_Neutral_Expr.png")
}

@onready var player : AnimationPlayer = %AnimationPlayer
@onready var head_material : Material = %Head_004.get_active_material(0)

func _ready() -> void:
	expression_test()

func change_expression(expression: String = "Neutral") ->void:
	print(head_material.emission_texture, " ", expressions[expression])
	head_material.emission_texture = expressions[expression]

func expression_test() -> void:
	while true:
		for face in expressions:
			print(face)
			change_expression(face)
			await get_tree().create_timer(2.0).timeout

func play_animation(anim: String = "Idle") -> void:
	if player.has_animation(anim):
		player.play(anim)
	else:
		push_error("Invalid animation set to ", name, ": ", anim)

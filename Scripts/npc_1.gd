extends Node3D

var expressions : Dictionary = {
	"Angry" : load("res://Assets/Characters/npc1/faces/Slade_Angy_Expr.png"),
	"Angry Talk" : load("res://Assets/Characters/npc1/faces/Slade_AngyTalk_Expr.png"),
	"Talk" : load("res://Assets/Characters/npc1/faces/Slade_Talk_Expr.png"),
	"Talk 2" : load("res://Assets/Characters/npc1/faces/Slade_Talk_Expr2.png"),
	"Neutral" : load("res://Assets/Characters/npc1/faces/Slade_Neutral_Expr.png")
}

var animations : Array = [
	"Idle",
	"Attention",
	"OneHandTalk",
	"TwoHandTalk",
	"SmallTalk",
	"TPose",
	"Thinky",
	"DiceShake"
]

@onready var player : AnimationPlayer = %AnimationPlayer
@onready var head_material : Material = %Hair.get_active_material(1)

func _ready() -> void:
	play_animation("Idle")

func expression_test() -> void:
	while true:
		for face in expressions:
			change_expression(face)
			await get_tree().create_timer(2.0).timeout

func animation_test() -> void:
	while true:
		for anim in player.get_animation_list():
			await play_animation(anim)

func change_expression(expression: String = "Neutral") ->void:
	if expressions.keys().has(expression):
		head_material.emission_texture = expressions[expression]

func play_animation(anim: String = "Idle") -> bool:
	if anim == player.current_animation:
		await player.animation_finished
		return true
	if player.has_animation(anim):
		player.play(anim)
		await player.animation_finished
	else:
		push_error("Invalid animation set to ", name, ": ", anim)
	
	return true

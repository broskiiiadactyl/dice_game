extends Node3D

@onready var player : AnimationPlayer = %AnimationPlayer

func float() -> bool:
	player.play("floating")
	await player.animation_finished
	return true

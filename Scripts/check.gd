extends MeshInstance2D

@export var sway_speed : float = 5.0

var time_passed : float = 0.0

var can_animate : bool = true

func animate() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", rotation - (2*PI) - 0.5, .25)
	await tween.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", rotation + 0.5, .1)

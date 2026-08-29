extends RichTextLabel

@export var target_3d: Node3D 
@onready var camera = %"Player Camera"
@onready var position_marker : Vector3 

var is_talking : bool = false

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout

func _process(_delta: float) -> void:
	if not target_3d:
		return
	
	if not camera:
		visible = false
		return
	
	if target_3d.name == "PlayerSpeech":
			position_marker = %PlayerSpeech.global_position
	else:
		position_marker = target_3d.get_node("%Speech").global_position
	
	if camera.is_position_behind(position_marker) or not is_talking:
		visible = false
	elif is_talking:
		visible = true
		var screen_pos = camera.unproject_position(position_marker)
		var offset : Vector2 = resize_offset()
		position = screen_pos - offset

func speak(dialogue: String, time: float, expression: String, anim: String) -> bool:
	text = dialogue
	
	if target_3d.name != "PlayerSpeech":
		if anim != "same":
			target_3d.play_animation(anim)
		if expression != "same":
			target_3d.change_expression(expression)
	
	is_talking = true
	await get_tree().create_timer(time).timeout
	is_talking = false
	
	#if target_3d.name != "PlayerSpeech":
		#var check : bool = false if anim == "same" else true
		#print("check: ", check)
		#if check:
			#print("sending reset")
			#target_3d.play_animation("Idle")
		#if expression != "same":
			#target_3d.change_expression("Neutral")
	
	return true

func resize_offset() -> Vector2:
	return size / 2

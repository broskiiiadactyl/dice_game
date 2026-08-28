extends Node3D

var events : Array[String] = [
	"gib_float",
	"hormse",
	"nothing"
]

@onready var timer : Timer = %"Random Event"
var random_min : float = 5.0
var random_max : float = 15.0

@onready var gibzo : Node3D = %Gibzo
@onready var hormse : Node3D = %hormse

func play_event(event: String, instant: bool = false) -> bool:
	match event:
		"gib_float":
			gibzo.process_mode = Node.PROCESS_MODE_INHERIT
			await gibzo.float()
			if instant:
				return true
			gibzo.process_mode = Node.PROCESS_MODE_DISABLED
		"hormse":
			hormse.process_mode = Node.PROCESS_MODE_INHERIT
			var start_pos : Vector3 = hormse.global_position
			var tween = get_tree().create_tween()
			tween.tween_property(hormse, "global_position", Vector3(-6.131, 0.0, 5.23), 1.0)
			await tween.finished
			tween.kill()
			
			if instant:
				return true
			
			await get_tree().create_timer(2.0).timeout
			
			tween = get_tree().create_tween()
			tween.tween_property(hormse, "global_position", start_pos, 1.0)
			await tween.finished
			tween.kill()
			hormse.process_mode = Node.PROCESS_MODE_DISABLED
		_:
			pass
	
	return true

func play_all_events() -> bool:
	for event in events:
		play_event(event, true)
	await get_tree().create_timer(1.0).timeout
	return true

func pick_event() -> String:
	return events[randi_range(0, events.size() - 1)]

func _on_random_event_timeout() -> void:
	await play_event(pick_event())
	
	timer.start(randf_range(random_min, random_max))

extends Node3D

#You can add whatever dice models you want under the %Models node
#The code will clear it and use the globals to ensure the player only has access to unlocked dice
#This way we can see and test while building -z

#dict for active dice models
var cupses : Dictionary

#models parent
@onready var model_container : Node3D = %Models

#shaker sound managment
@onready var shaker_sound : AudioStreamPlayer3D = %"Shaker Sound"
@onready var shaker_timer : Timer = %"Shake Sound Timer"
var last_pos : Vector3
@export var shake_distance : float = 0.05
var is_shaking : bool = false
var can_play_sound : bool = true

var mouse_over : bool = false

func _ready() -> void:
	cupses = Globals.cup_dict
	
	#remove all existing models under %Models
	var dump_children : Array = model_container.get_children()
	for child in dump_children:
		child.queue_free()
	
	#Pull all the dice from the player dictionary
	#Parent them under the %Models node
	#set visibility to false
	for cup in cupses:
		if cupses[cup] is not String:
			continue
		var new_dice = load(cupses[cup])
		var model_instance = new_dice.instantiate()
		model_instance.name = cup
		model_container.add_child(model_instance)
		model_instance.visible = false
	
	set_cup("can")

func _physics_process(_delta: float) -> void:
	#if last_pos == null:
		#last_pos = global_position
	
	if last_pos.distance_to(global_position) >= shake_distance and can_play_sound:
		play_shaker_sound()
	else:
		is_shaking = false
	
	#if last_pos != global_position:
		#print(last_pos, ", ", global_position, ", ", last_pos.distance_to(global_position))
	
	set_deferred("last_pos", global_position)

#function to set active dice model
func set_cup(model: String) -> void:
	
	for child in model_container.get_children():
		if child.name == model:
			child.visible = true
		else:
			child.visible = false

func play_shaker_sound() -> void:
	if shaker_timer.is_stopped():
		shaker_sound.play()
		shaker_timer.start()


func _on_cup_collision_mouse_entered() -> void:
	mouse_over = true


func _on_cup_collision_mouse_exited() -> void:
	mouse_over = false

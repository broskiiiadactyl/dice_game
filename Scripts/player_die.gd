extends RigidBody3D

#You can add whatever dice models you want under the %Models node
#The code will clear it and use the globals to ensure the player only has access to unlocked dice
#This way we can see and test while building -z

#dict for active dice models
var deece : Dictionary

#models parent
@onready var model_container : Node3D = %Models

func _ready() -> void:
	deece = Globals.dice_dict
	
	#remove all existing models under %Models
	var dump_children : Array = model_container.get_children()
	for child in dump_children:
		child.queue_free()
	
	#Pull all the dice from the player dictionary
	#Parent them under the %Models node
	#set visibility to false
	for die in deece:
		if deece[die] is not String:
			continue
		var new_dice = load(deece[die])
		var model_instance = new_dice.instantiate()
		model_instance.name = die
		model_container.add_child(model_instance)
		model_instance.visible = false
		model_instance.scale *= 0.1
	
	set_dice("normal")

#function to set active dice model
func set_dice(model: String) -> void:
	
	for child in model_container.get_children():
		if child.name == model:
			child.visible = true
		else:
			child.visible = false

extends RigidBody3D

@export var models : Dictionary[String,PackedScene]
var deece : Dictionary

@onready var model_container : Node3D = %Models

func _ready() -> void:
	deece = Globals.dice_dict
	
	#Pull all the dice from the player dictionary
	for die in deece:
		if die is not String:
			continue
		models[die] = load(deece[die])
	
	#Load in all the available dice models
	#Parent them under the %Models node
	#set visibility to false
	for model in models:
		var model_instance = models[model].instantiate()
		model_instance.name = model
		model_container.add_child(model_instance)
		model_instance.visible = false
		
	set_dice("normal")

func set_dice(model: String) -> void:
	if model_container.has_node(model):
		model_container.get_node(model).visible = true

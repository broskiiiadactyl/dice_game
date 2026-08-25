extends RigidBody3D

#You can add whatever dice models you want under the %Models node
#The code will clear it and use the globals to ensure the player only has access to unlocked dice
#This way we can see and test while building -z

#dict for active dice models
var deece : Dictionary

#models parent
@onready var model_container : Node3D = %Models

@onready var label : Label3D = %Label3D

func _ready() -> void:
	label.visible = false
	
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

func _process(delta: float) -> void:
	%Label3D.global_position = global_position + Vector3.UP * 0.1
	%Label3D.global_rotation = Vector3.UP
	
	if linear_velocity.is_zero_approx():
		%Label3D.text = str(check_value())
		label.visible = true
	else:
		label.visible = false

#function to set active dice model
func set_dice(model: String) -> void:
	
	for child in model_container.get_children():
		if child.name == model:
			child.visible = true
		else:
			child.visible = false

#this function checks which face is pointing up by checking the die's rotation in global space
#VERY IMPORTANT: for this to work, the orientation of the dice MUST match the attached Normal Die model
func check_value() -> int:
	var check_basis: Basis = global_transform.basis

	var x_up: float = check_basis.x.y
	var y_up: float = check_basis.y.y
	var z_up: float = check_basis.z.y

	if abs(y_up) >= abs(x_up) and abs(y_up) >= abs(z_up):
		if y_up > 0.0:
			return 6
		else:
			return 1
	
	elif abs(x_up) >= abs(z_up):
		if x_up > 0.0:
			return 2
		else:
			return 5
	
	else:
		if z_up > 0.0:
			return 3
		else:
			return 4

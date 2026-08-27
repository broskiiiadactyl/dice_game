extends RigidBody3D

#You can add whatever dice models you want under the %Models node
#The code will clear it and use the globals to ensure the player only has access to unlocked dice
#This way we can see and test while building -z

#dict for active dice models
var deece : Dictionary

#models parent
@onready var model_container : Node3D = %Models

@onready var label : Label3D = %Label3D

var dice_value : int = 0
var can_display : bool = false

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

func display_value(on: bool) -> void:
	if on:
		%Label3D.global_position = global_position + Vector3.UP * 0.1
		%Label3D.global_rotation = Vector3.UP
		var value : int = check_value()
		dice_value = value
		%Label3D.text = str(value)
		label.visible = true
	else:
		label.visible = false

#orient die so it is orthogonal based on current rotation
func snap_to_world_axes() -> void:
	var current_basis : Basis = global_basis
	
	var target_x : Vector3 = get_closest_axis(current_basis.x)
	var target_y : Vector3 = get_closest_axis(current_basis.y)
	var target_z : Vector3 = get_closest_axis(current_basis.z)
	
	if target_z.is_zero_approx():
		target_z = get_closest_axis(current_basis.z)
		target_x = target_y.cross(target_z).normalized()
	else:
		target_y = target_z.cross(target_x).normalized()
	
	global_basis = Basis(target_x, target_y, target_z)
	
	

func get_closest_axis(local_axis : Vector3) -> Vector3:
	var world_vectors : Array[Vector3] = [
		Vector3.UP,
		Vector3.DOWN,
		Vector3.LEFT,
		Vector3.RIGHT,
		Vector3.FORWARD,
		Vector3.BACK
	]
	
	var closest_vector : Vector3 = Vector3.UP
	var max_dot : float = -2.0
	
	for vec in world_vectors:
		var dot : float = local_axis.normalized().dot(vec)
		if dot > max_dot:
			max_dot = dot
			closest_vector = vec
	
	return closest_vector

extends Camera3D

@export_group("Bounds") #in degrees from camera origin
@export var max_yaw : float = 100.0
@export var max_pitch : float = 5.0
@export var move_scale : float = 0.25

#init starting camera position as the origin from which to calculate relative mouse position
@onready var start_basis : Basis = self.basis

func _process(_delta: float) -> void:
	if Globals.can_move:
		#get visible window bounds and mouse position
		var rect : Rect2 = get_viewport().get_visible_rect()
		var mouse : Vector2 = get_viewport().get_mouse_position()
		
		#clamp mouse position to window bounds
		mouse = mouse.clamp(rect.position, rect.end)
		
		#normalize mouse to camera basis
		var normalized = ((mouse - rect.size/2) / (rect.size/2)) * move_scale
		
		#clamp pitch (y) and yaw (x) within defined bounds
		var yaw = deg_to_rad(-normalized.x * max_yaw)
		var pitch = deg_to_rad(-normalized.y * max_pitch)
		
		#set everyting
		basis = start_basis
		rotate_y(yaw)
		rotate_object_local(Vector3.RIGHT, pitch)

extends Node3D

@onready var controller_dict = {
	"npc1" : $"Slade Screen",
	"npc2" : $"Boone Screen",
	"npc3" : $"Vickie Screen"
}

var num_of_dice : int

#(status : String, active: int = num_of_dice) -> bool:
func sort_npc_screen_update(npc : String, status : String, active: int = num_of_dice):
	if npc == 'player':
		return
	await controller_dict[npc].update_screen(status,active)

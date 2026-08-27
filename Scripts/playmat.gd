extends Node3D

@onready var slot_dict : Dictionary = {
	"d1" = %"Dice Slot1".get_node("%Placer"),
	"d2" = %"Dice Slot2".get_node("%Placer"),
	"d3" = %"Dice Slot3".get_node("%Placer"),
	"d4" = %"Dice Slot4".get_node("%Placer"),
	"d5" = %"Dice Slot5".get_node("%Placer")
}

@onready var cup_placer : Marker3D = %"Cup Placer"
@onready var better : Node3D = %BET
@onready var caller : Node3D = %CALL

func _ready() -> void:
	better.set_text("BET")
	better.set_color("INACTIVE")
	caller.set_text("CALL")
	caller.set_color("INACTIVE")

func set_buttons(on: bool) -> void:
	if on:
		better.set_color("BET")
		caller.set_color("CALL")
	else:
		better.set_color("INACTIVE")
		caller.set_color("INACTIVE")

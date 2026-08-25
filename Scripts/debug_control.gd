extends Control

@onready var chkval_btn : Button = $check_value_button

func _ready() -> void:
	chkval_btn.pressed.connect(_on_button_clicked)
	pass

func _on_button_clicked():
	print('this is a test!')

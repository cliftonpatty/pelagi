@tool
extends Control

@onready var fishButton : Button = $MarginContainer/VBoxContainer/HBoxContainer/Button

signal update_button_pressed

func _ready() -> void:
	fishButton.pressed.connect(button_pressed)
	

func button_pressed():
	emit_signal("update_button_pressed")

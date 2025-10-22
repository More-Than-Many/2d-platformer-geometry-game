extends Control

@export var ButtonVContainer : VBoxContainer

@export var StartButton : Button
@export var OptionsButton : Button
@export var QuitButton : Button

var buttons := []

@export var SFX_Button : AudioStreamPlayer


func _ready() -> void:
	for child in ButtonVContainer.get_children():
		if child is Button:
			buttons.append(child)
	
	for button in buttons:
		button.connect("mouse_entered", on_button_hovered)

func on_button_hovered():
	SFX_Button.play()
		

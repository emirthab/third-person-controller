@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ThirdPersonController", "CharacterBody3D", preload("res://addons/ThirdPersonTemplate/Character/Scripts/PlayerTemplate.gd"), preload("icon.svg"))

func _exit_tree():
	remove_custom_type("ThirdPersonController")

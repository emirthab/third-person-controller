extends Node3D

@onready var Player = get_parent()

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() != 0:
		var resultant = sqrt((event.relative.x * event.relative.x ) + (event.relative.y * event.relative.y ))
		var rot = Vector3(event.relative.y,-event.relative.x,0).normalized()
		rotate_object_local(rot , resultant * Player.MouseSensitivity)
		rotation.z = clamp(rotation.z,deg2rad(-0),deg2rad(0))
		rotation.x = clamp(rotation.x,deg2rad(-30),deg2rad(30))

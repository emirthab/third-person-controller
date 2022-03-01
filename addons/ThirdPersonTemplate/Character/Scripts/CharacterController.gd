@tool
extends	CharacterBody3D

@export_enum("Rotate", "Strafe") var LocomationType	= 0
@export	var	Gravity	: float	= 25
@export	var	JumpForce :	float =	10
@export	var	DefaultSpeed : float = 3.5
@export	var	SpeedUp	: float	= 7.0
@export	var	MouseSensitivity : float = 0.004
@export	var	DecelerationFactor : float = 10.0
@export	var	AccelerationFactor : float = 5.0	
@export	var	PivotPath :	NodePath = "Pivot"

var	SPEED :	float
@onready var Pivot = get_node(PivotPath)

var	inputDir : Vector2
var	direction :	Vector3

func _enter_tree():
	var armature = preload("res://addons/ThirdPersonTemplate/Character/Nodes/Armature.gltf").instantiate()
	var collider = preload("res://addons/ThirdPersonTemplate/Character/Nodes/CollisionShape3D.res")
	var locoStrafe = preload("res://addons/ThirdPersonTemplate/Character/Nodes/LocomationStrafe.res")
	var locoRot = preload("res://addons/ThirdPersonTemplate/Character/Nodes/LocomationRotate.res")
	var pivot = preload("res://addons/ThirdPersonTemplate/Character/Nodes/Pivot.res")
	var interpolatedCamera = preload("res://addons/ThirdPersonTemplate/Character/Nodes/InterPolatedCamera.tscn")
	
	armature.scale = Vector3(0.02, 0.02, 0.02)
	#armature.size = Vector3(0.02,0.02,0.02)
	add_child(armature)
	add_child(collider.instantiate())
	add_child(locoStrafe.instantiate())
	add_child(locoRot.instantiate())
	add_child(pivot.instantiate())
	add_child(interpolatedCamera.instantiate())

func _ready():
	if !Engine.is_editor_hint():
		if LocomationType == 1:
			get_node("LocomationStrafe").active	= true
		else:
			get_node("LocomationRotate").active	= true

		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if !Engine.is_editor_hint():
		if not is_on_floor():
			motion_velocity.y -= Gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			motion_velocity.y =	JumpForce

		inputDir = Input.get_vector("ui_left", "ui_right", "ui_up",	"ui_down")
		direction =	-( (Pivot.transform.basis *	global_transform.basis)	* Vector3(inputDir.x, 0, inputDir.y)).normalized()
		SPEED =	SpeedUp	if Input.is_key_pressed(KEY_SHIFT) else	DefaultSpeed

		if direction:
			motion_velocity.x =	lerp(motion_velocity.x,	direction.x	* SPEED, AccelerationFactor	* delta)
			motion_velocity.z =	lerp(motion_velocity.z,	direction.z	* SPEED, AccelerationFactor	* delta)
		else:
			motion_velocity.x =	lerp(motion_velocity.x,	0, DecelerationFactor *	delta)
			motion_velocity.z =	lerp(motion_velocity.z,	0, DecelerationFactor *	delta)
		
		move_and_slide()


func _input(event):
	var	just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_ESCAPE)	and	just_pressed:
		if Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

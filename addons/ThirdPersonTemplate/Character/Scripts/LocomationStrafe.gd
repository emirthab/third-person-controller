extends AnimationTree

@onready var Player = get_parent()
@onready var StateMachine = get("parameters/playback")
@onready var Armature = Player.get_node("Armature")

func _process(delta):
	if active:
		var directionalSpeedMagnitude : float = sqrt( pow(Player.motion_velocity.x, 2) + pow(Player.motion_velocity.z, 2) )
		var movementState : Vector2 = directionalSpeedMagnitude * Player.inputDir / Player.SpeedUp
		var state = getMovementState()
		var x = lerp(state.x, movementState.x, 10 * delta)
		var y = lerp(state.y, movementState.y, 10 * delta)
		SetMovementState(Vector2(x,y))

		var rotationDir = Player.Pivot.rotation.y
		Armature.rotation.y = lerp_angle(Armature.rotation.y, rotationDir, delta * 5)
		
		if Player.is_on_floor():
			if StateMachine.get_current_node() == "FallingIdle":
				setJumping(false)
				StateMachine.travel("JumpingDown")
			if Player.direction:
				setJumping(false)
		elif (Player.motion_velocity.y < Player.JumpForce):
			setJumping(true)
			StateMachine.travel("FallingIdle")

func SetMovementState(state) : set("parameters/Movement/Movement/blend_position",state)
func getMovementState() -> Vector2: return get("parameters/Movement/Movement/blend_position")

func setJumping(state) : set("parameters/Movement/JumpEvent/active",state)
func getJumping() : return get("parameters/Movement/JumpEvent/active")

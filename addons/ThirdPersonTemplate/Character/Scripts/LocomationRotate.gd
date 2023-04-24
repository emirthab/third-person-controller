extends AnimationTree

@onready var Player = get_parent()
@onready var StateMachine = get("parameters/playback")
@onready var Armature = Player.get_node("Armature")

func _physics_process(delta):
	if active:
		if Player.velocity.y == Player.JumpForce:
			StateMachine.travel("JumpingUp")

		if Player.direction:
			var rotationDir = -( Player.Pivot.transform.basis * Vector3(Player.inputDir.x, 0, Player.inputDir.y)).normalized()
			Armature.rotation.y = lerp_angle(Armature.rotation.y, atan2(rotationDir.x,rotationDir.z), delta * 5)

		var directionalSpeedMagnitude : float = sqrt( pow(Player.velocity.x, 2) + pow(Player.velocity.z, 2) )
		SetMovementState((directionalSpeedMagnitude / Player.SpeedUp))

		if Player.is_on_floor():
			if StateMachine.get_current_node() == "FallingIdle":
				StateMachine.travel("JumpingDown")
			if Player.direction:
				StateMachine.travel("Movement")
		elif Player.velocity.y < Player.JumpForce:
			StateMachine.travel("FallingIdle")

func SetMovementState(state) : set("parameters/Movement/blend_position",state)

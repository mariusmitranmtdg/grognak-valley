extends CharacterBody2D

@onready var msm = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")

var direction: Vector2
var speed := 50

func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func get_basic_input():
	if Input.is_action_just_pressed("action"):
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func animate():
	if direction:
		msm.travel("Walk")
		var animation_direction := Vector2(round(direction.x), round(direction.y))
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", animation_direction)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", animation_direction)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animation_name: String =("parameters/ToolStateMachine/"+ animation +"/blend_position")
			$Animation/AnimationTree.set(animation_name, animation_direction)
	else:
		msm.travel("Idle")

func tool_use_emit():
	print('tool')

func _physics_process(_delta: float) -> void:
	get_basic_input()
	move()
	animate()

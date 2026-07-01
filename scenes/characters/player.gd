extends CharacterBody2D

@onready var msm = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tsm = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")

var direction: Vector2
var speed := 200
var current_tool: Enum.Tool
var current_seed: Enum.Seed
var can_move: bool = true

func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func get_basic_input():
	if Input.is_action_just_pressed("tool_backward") or Input.is_action_just_pressed("tool_forward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod((current_tool + int(dir)), Enum.Tool.size()) as Enum.Tool
	
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = posmod(current_seed + 1, Enum.Seed.size()) as Enum.Seed
		print(current_seed)
	if Input.is_action_just_pressed("action"):
		tsm.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
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
	if can_move:
		get_basic_input()
		move()
		animate()


func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false

func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true

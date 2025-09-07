extends State

@export var walk_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

	play_idle_animation()

func play_idle_animation() -> void:
	var dir = parent.last_direction

	if abs(dir.x) > abs(dir.y):
		# Side idle
		parent.animations.play("side_idle")
		parent.sprite.flip_h = dir.x < 0
	else:
		if dir.y > 0:
			parent.animations.play("front_idle")
		else:
			parent.animations.play("back_idle")

func process_input(event: InputEvent) -> State:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return walk_state
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return walk_state
	return null

func process_physics(delta: float) -> State:
	return null

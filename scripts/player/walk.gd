extends State

@export var idle_state: State



func process_input(event: InputEvent) -> State:
	# If no input at all, go back to idle
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (
		not Input.is_action_pressed("move_up") and
		not Input.is_action_pressed("move_down") and
		not Input.is_action_pressed("move_left") and
		not Input.is_action_pressed("move_right")
	):
		return idle_state

	if event is InputEventMouseButton and not event.pressed:
		if not using_keyboard_input():
			return idle_state

	return null

func process_physics(delta: float) -> State:
	var direction = Vector2.ZERO

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		direction = (parent.get_global_mouse_position() - parent.global_position).normalized()
	else:
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		direction = direction.normalized()

	if direction == Vector2.ZERO:
		parent.velocity = Vector2.ZERO
		return idle_state

	# Apply movement
	parent.velocity = direction * move_speed
	parent.update_last_direction(direction)


	# 🔁 Play directional animation
	play_directional_animation(direction)

	return null

func play_directional_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		# Side movement (left or right)
		parent.animations.play("side_walk")
		parent.sprite.flip_h = direction.x < 0  # Flip if moving left
	else:
		if direction.y > 0:
			parent.animations.play("front_walk")
		else:
			parent.animations.play("back_walk")


func using_keyboard_input() -> bool:
	return Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

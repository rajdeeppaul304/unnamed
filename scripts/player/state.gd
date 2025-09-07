class_name State
extends Node

@export var move_speed: float = 300

var parent: Player  # Holds reference to the player, which contains animations

func enter() -> void:
	# No animation logic here anymore
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

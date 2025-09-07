class_name Player
extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var state_machine = $state_machine
@onready var sprite = $Sprite2D  
var last_direction: Vector2 = Vector2(0, 1)  # Default facing down/front

func update_last_direction(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func is_player():
	pass

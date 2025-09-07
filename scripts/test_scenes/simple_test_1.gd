extends Node2D
@onready var door: Area2D = $Node/Area2D
@onready var player_scene: Player = $"Player-scene"




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		print("body entered")

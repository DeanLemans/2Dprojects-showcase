extends Node2D

var direction : Vector2 = Vector2.ZERO
var animation_player : AnimationPlayer

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		# Delay the scene change until the physics callback is finished
		call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/lost.tscn")

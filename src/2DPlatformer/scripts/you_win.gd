extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		# Delay the scene change until the physics callback is finished
		call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/win.tscn")

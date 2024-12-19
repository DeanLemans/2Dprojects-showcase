extends Node2D

func _on_to_1_pressed():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/tutorial.tscn")

func _on_to_2_pressed():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/level_2.tscn")

func _on_to_3_pressed():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/level_3.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://2DPlatformer/Scenes/mainMenu.tscn")

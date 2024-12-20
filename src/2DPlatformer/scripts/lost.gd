extends Node2D

func _process(_delta):
	if Input.is_action_pressed("quit scene"):
		get_tree().change_scene_to_file("res://2DPlatformer/Scenes/mainMenu.tscn")

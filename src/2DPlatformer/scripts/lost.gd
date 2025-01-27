extends Node2D

var scene_changed = false

func _process(_delta):
	if Input.is_action_pressed("quit") and not scene_changed:
		get_tree().change_scene_to_file("res://2DPlatformer/Scenes/mainMenu.tscn")
		scene_changed = true
	elif not Input.is_action_pressed("quit"):
		scene_changed = false

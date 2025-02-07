extends Node2D

@export_file("*.tscn") var game_path : String

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file(game_path)

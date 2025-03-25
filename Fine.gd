extends Control

func _on_main_menù_pressed():
	get_tree().change_scene_to_file("res://main_menù.tscn")

func _on_exit_pressed():
	get_tree().quit()

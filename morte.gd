extends Control

@onready var Morte : AudioStreamPlayer = $"Morte"

func _ready():
	Morte.play()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_main_menù_pressed():
	get_tree().change_scene_to_file("res://main_menù.tscn")


func _on_exit_pressed():
	get_tree().quit()

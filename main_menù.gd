extends Node

@onready var Main: Control = $"CanvasLayer/Main"
@onready var Settings: Control = $"CanvasLayer/Settings"
@onready var Musica: Control = $"CanvasLayer/Musica"

var master_bus_pausa = AudioServer.get_bus_index("Master pausa")
var master_bus_main = AudioServer.get_bus_index("Master main")
var master_bus_gioco = AudioServer.get_bus_index("Master gioco")

@onready var Musica_del_main : AudioStreamPlayer = $"Principale"

func _ready():
	Musica_del_main.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Video/Cutscene.tscn")

func _on_settings_pressed() -> void:
	Main.visible = false
	Settings.visible = true
	Musica.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_settings_pressed() -> void:
	Main.visible = true
	Settings.visible = false
	Musica.visible = false

func _on_musica_pressed() -> void:
	Main.visible = false
	Settings.visible = false
	Musica.visible = true

func _on_back_musica_pressed():
	Main.visible = false
	Settings.visible = true
	Musica.visible = false

func _on_h_slider_menù_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_main, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_main, true)
	else:
		AudioServer.set_bus_mute(master_bus_main, false)

func _on_h_slider_pausa_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_pausa, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_pausa, true)
	else:
		AudioServer.set_bus_mute(master_bus_pausa, false)

func _on_h_slider_gioco_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_gioco, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_gioco, true)
	else:
		AudioServer.set_bus_mute(master_bus_gioco, false)

func _on_musica_main_menù_finished():
	Musica_del_main.play()
	

extends Control

@export var game_manager : GameManager

@onready var Main: Panel = $Main
@onready var Settings: Panel = $Settings
@onready var Musica: Panel = $Musica
@onready var Musica_pausa : AudioStreamPlayer = $"Musica pausa"

var master_bus_pausa = AudioServer.get_bus_index("Master pausa")
var master_bus_main = AudioServer.get_bus_index("Master main")
var master_bus_gioco = AudioServer.get_bus_index("Master gioco")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if (is_paused):
		Musica_pausa.play()
		show()
	else:
		Musica_pausa.stop()
		game_manager.Musica_gioco.play()
		hide()

func _on_resume_pressed():
	game_manager.Musica_gioco.play()
	game_manager.game_paused = false

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	Main.visible = false
	Settings.visible = true
	Musica.visible = false

func _on_musica_pressed():
	Main.visible = false
	Settings.visible = false
	Musica.visible = true

func _on_back_pressed():
	Main.visible = true
	Settings.visible = false
	Musica.visible = false

func _on_back_musica_pressed():
	Main.visible = false
	Settings.visible = true
	Musica.visible = false

func _on_return_to_main_menù_pressed():
	game_manager.game_paused = false
	get_tree().change_scene_to_file("res://main_menù.tscn")

func _on_h_slider_pausa_value_changed(value): #Pausa
	AudioServer.set_bus_volume_db(master_bus_pausa, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_pausa, true)
	else:
		AudioServer.set_bus_mute(master_bus_pausa, false)

func _on_h_slider_gioco_value_changed(value): #Gioco
	AudioServer.set_bus_volume_db(master_bus_gioco, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_gioco, true)
	else:
		AudioServer.set_bus_mute(master_bus_gioco, false)

func _on_h_slider_menù_value_changed(value): #Menù
	AudioServer.set_bus_volume_db(master_bus_main, value)
	if value == -30 :
		AudioServer.set_bus_mute(master_bus_main, true)
	else:
		AudioServer.set_bus_mute(master_bus_main, false)

func _on_musica_pausa_finished():
	Musica_pausa.play()

func _on_reset_pressed():
	game_manager.game_paused = false
	get_tree().change_scene_to_file("res://main.tscn")

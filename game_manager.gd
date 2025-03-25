extends Node

class_name GameManager 

signal toggle_game_paused(is_paused : bool)

@onready var player : CharacterBody2D = $Player
@onready var Musica_gioco : AudioStreamPlayer = $"Musica di gioco"
@onready var camera : Camera2D = $Camera2D
var master_bus_gioco = AudioServer.get_bus_index("Master gioco")
var file_path = "/AI/Server/main.py"  # Percorso relativo al file python
var path_exe = "/AI/Server/dist/main.exe"

func _ready():
	#start_server()
	#start_exe()
	
	AudioServer.set_bus_volume_db(master_bus_gioco, -20.0)
	Musica_gioco.play()
	camera.limit_right = 3455
	camera.limit_left = 0

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event : InputEvent):
	if (event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused
		Musica_gioco.stop()

func _on_musica_di_gioco_finished():
	Musica_gioco.play()


func _on_porta_level_2_body_entered(body):
	if body is Player:
		body.position.x = 5314
		body.position.y = 397
		camera.position.x = 5314
		camera.position.y = 397
		camera.limit_left = 5195
		camera.limit_right = 9650
	else:
		pass

func _on_porta_level_3_body_entered(body):
	if body is Player:
		body.position.x = 11400
		body.position.y = 397
		camera.position.x = 11480
		camera.position.y = 397
		camera.limit_left = 11290
		camera.limit_right = 15750
	else:
		pass

func _on_porta_level_4_body_entered(body):
	if body is Player:
		body.position.x = 16895
		body.position.y = 397
		camera.position.x = 16895
		camera.position.y = 397
		camera.limit_left = 16689
		camera.limit_right = 18707
	else:
		pass

func _on_ventola_body_entered(body):
	if body is Player:
		body.position.x = 16895
		body.position.y = -107
		camera.position.x = 16895
		camera.position.y = 397
		camera.limit_left = 16689
		camera.limit_right = 18707
	else:
		pass

func _on_porta_finale_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://Video/boss_battle.tscn")

func start_server():
	var python_exe = "python"  # O "python3" su alcuni sistemi
	var abs_path = ProjectSettings.globalize_path("res://" + file_path)

	if FileAccess.file_exists(abs_path):
		var process_id = OS.create_process(python_exe, [abs_path], false)
		if process_id != -1:
			print("Server avviato correttamente.")
		else:
			print("Errore nell'avvio del server.")
	else:
		print("File non trovato:", abs_path)

func start_exe():
	var abs_path = ProjectSettings.globalize_path("res://" + path_exe)  # Converte in percorso assoluto
	
	if FileAccess.file_exists(abs_path):  # Controlla se il file esiste
		var result = OS.create_process(abs_path, [])
		if result:
			print("File avviato correttamente.")
		else:
			print("Errore nell'avvio del file.")
	else:
		print("File non trovato:", abs_path)

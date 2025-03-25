extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Skippa") :
		get_tree().change_scene_to_file("res://main_menù.tscn")

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://main_menù.tscn")

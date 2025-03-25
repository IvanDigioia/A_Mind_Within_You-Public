extends Area2D

@export var game_manager : GameManager

func _on_body_entered(body):
	if body is Player:
		#print(get_tree().change_scene_to_file("res://level_" + str(int(get_tree().current_scene.name.to_int())+ 1 ) + ".tscn"))
		#get_tree().change_scene_to_file("res://level_2.tscn")
		body.position.x = 4445
		body.position.y = 397
		game_manager.camera.limit_right=3455
		

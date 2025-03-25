extends Node

class_name Damageable

func hit (damage : float):
	var body = get_parent()
	if(body is Enemy):
		body.HEALTH_ENEMY -= damage
		print(body.HEALTH_ENEMY)
		if body.HEALTH_ENEMY <= 0:
			death(body)
	elif(body is Player):
		var current = body.PLAYER_HP.get_current()
		current -= damage
		body.Suono_hit.play()
		body.PLAYER_HP.set_current(current)
		if body.PLAYER_HP.get_current() <= 0:
			death(body)
	elif(body is EnemyGuard):
		body.HEALTH_ENEMY -= damage
		print(body.HEALTH_ENEMY)
		if body.HEALTH_ENEMY <= 0:
			death(body)

func death(body):
	if(body is Enemy):
		body.SPEED_ENEMY = 0.0
		body.Player_chase = false
		body.Suono_morte.play()
		body.animated_sprite.play("Death")
		body.Collision.queue_free()
	elif(body is EnemyGuard):
		body.SPEED_ENEMY = 0.0
		body.Player_chase = false
		body.Suono_morte.play()
		body.animated_sprite.play("Death")
		body.Collision.queue_free()
	elif (body is Player):
		get_tree().change_scene_to_file("res://morte.tscn")

extends CharacterBody2D

class_name Enemy

var HEALTH_ENEMY : float = 120
var SPEED_ENEMY : float = 150
var T = HEALTH_ENEMY
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var Collision : CollisionShape2D = $CollisionShape2D
@onready var Suono_morte : AudioStreamPlayer = $"Morte"
var master_bus_morte = AudioServer.get_bus_index("Master morte zombie")

var target : Player
var Player_chase : bool = false;

const time_delay : float = 1.3

var timer : Timer

@export var projectile : PackedScene  
@onready var spawn_projectile : Marker2D = $ProjectileSpawn2



func _physics_process(delta : float):
	if target == null:
		if get_tree().get_nodes_in_group("PlayersGroup")[0] != null :
			target = get_tree().get_nodes_in_group("PlayersGroup")[0]
	else:
		move_enemy()
		
	if T > HEALTH_ENEMY:
		animated_sprite.play("Damage")
		T = HEALTH_ENEMY
		if HEALTH_ENEMY == 0:
			animated_sprite.play("Death")


func move_enemy():
	if(Player_chase == true) and (HEALTH_ENEMY != 0):
		animated_sprite.play("Attack")
		velocity.x = position.direction_to(target.position).x * SPEED_ENEMY
		move_and_slide()
		if position.direction_to(target.position).x > 0:
			animated_sprite.set_flip_h(false) 
		elif  position.direction_to(target.position).x < 0: 
			animated_sprite.set_flip_h(true)
	elif (Player_chase == false) and (HEALTH_ENEMY != 0):
		animated_sprite.play("Stay")
	elif (Player_chase == true) and (HEALTH_ENEMY == 0):
		animated_sprite.play("Death")

func delay_shoot():
	timer = Timer.new()
	if(Player_chase == true or HEALTH_ENEMY > 0):
		add_child(timer)
		timer.wait_time = time_delay
		timer.timeout.connect(func(): shoot())
		timer.start()
	else:
		timer.stop()

func shoot() -> void:
	if HEALTH_ENEMY > 0:
		var instanceEnemy : Projectile = projectile.instantiate() 
		var dir = (target.global_position - global_position).normalized()

		owner.add_child(instanceEnemy)
		instanceEnemy.spawned_from = self
		instanceEnemy._setDirection(velocity)
		instanceEnemy._setSpriteDirection(animated_sprite)
		instanceEnemy.transform = spawn_projectile.get_global_transform()
		instanceEnemy.global_rotation = dir.angle() + PI
		instanceEnemy.direction = dir
	else:
		return

func _on_detection_area_body_entered(body):
	if HEALTH_ENEMY>0:
		if(body is Player):
			target = body
			Player_chase = true
			delay_shoot()

func _on_detection_area_body_exited(body):
	if HEALTH_ENEMY>0:
		if(body is Player):
			timer.stop()
			target = body
			Player_chase= false

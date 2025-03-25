extends Area2D

class_name Projectile

var ProjectileSpeed : float = 25.0

var direction : Vector2 = Vector2.LEFT
var sprite_Player : AnimatedSprite2D

var damage : float = 20
const time_to_live : float = 2.0
var spawned_from : Node

@onready var ray : RayCast2D = $RayCast2D
@onready var sprite_projectile : AnimatedSprite2D = $SpriteProiettile

func _setDirection(directionGet : Vector2):
	direction = directionGet

func _setSpriteDirection(sprite : AnimatedSprite2D):
	sprite_Player = sprite

func _ready():
	sprite_projectile.play("ColpoZombie")
	handle_time_to_live()

func handle_time_to_live():
	var ttl_timer : Timer = Timer.new()
	add_child(ttl_timer)
	ttl_timer.wait_time = time_to_live
	ttl_timer.one_shot = false
	ttl_timer.timeout.connect(func() : queue_free())
	ttl_timer.start()

func _physics_process(delta : float):
		translate(direction * ProjectileSpeed)

func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(20)
	queue_free()

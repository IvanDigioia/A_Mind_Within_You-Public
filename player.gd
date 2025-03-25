extends CharacterBody2D

class_name Player

var screen_size # Size of the game window.

var can_move: bool = true #Il player si può muovere si o no

#Jump Variables
@export var jump_height : float = 200
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.5

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak*jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent*jump_time_to_descent)) * -1.0

#Sound Varibles
@onready var Suono_hit : AudioStreamPlayer = $"Hit"
var master_bus_hit = AudioServer.get_bus_index("Master hit")
var master_bus_morte = AudioServer.get_bus_index("Master morte player")

#Shield Variables
@onready var shield : Area2D = $Shield
@onready var shield2 : Area2D = $Shield2
@export var block_speed : float = 150.0

#Projectile variables

@onready var spawn_projectile : Marker2D = $ProjectileSpawn

#Animation Variables
@onready var player_animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

#Player Parameters
const MOVEMENTSPEED = 500
@onready var PLAYER_MP : ManaPlayer = $MPBarLayout/ManaNode/Mana
@onready var PLAYER_HP : HealthPlayer = $HealtBarLayout/HealthPlayer/Health
@onready var T = PLAYER_HP.get_current()

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_time_to_restore()
	handle_time_to_lose()
	screen_size = get_viewport_rect().size
	AudioServer.set_bus_volume_db(master_bus_hit, -10.0)
	AudioServer.set_bus_volume_db(master_bus_morte, -10.0)
	shield.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_move:
		var direction = Input.get_axis("move_left", "move_right")
		var currentMP = PLAYER_MP.get_current()
		if(Input.is_action_pressed("Shield") and currentMP != 0):
			if direction <= 0 and player_animated_sprite.flip_h == true:
				shield2.set_blocking(true)
				shield.set_blocking(false)
			elif direction >=0:
				shield.set_blocking(true)
				shield2.set_blocking(false)
		elif(!Input.is_action_pressed("Shield") || currentMP == 0):
			shield.set_blocking(false)
			shield2.set_blocking(false)

	move(delta)
	if T > PLAYER_HP.get_current():
		player_animated_sprite.play("Hit")
		T = PLAYER_HP.get_current()


# Movement Script

func move(delta) -> void:
	if can_move:
		velocity.y += get_gravity() * delta;
		# The player Directional movements
		var direction = Input.get_axis("move_left", "move_right")
		if direction == -1: #direszione a sinistra
			player_animated_sprite.set_flip_h(true) 
			velocity.x = direction * MOVEMENTSPEED
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				_jump();
		elif direction == 1: #direzione a destra
			player_animated_sprite.set_flip_h(false)  
			velocity.x = direction * MOVEMENTSPEED
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				_jump();
		elif Input.is_action_just_pressed("Jump") and is_on_floor():
			_jump();
		else:
			velocity.x = move_toward(velocity.x, 0, MOVEMENTSPEED)
	
		move_and_slide()
		if is_on_floor():
			velocity = velocity.normalized() * MOVEMENTSPEED
			
		if velocity.length()>0 and !is_on_floor():
			player_animated_sprite.play("Jump")
		elif velocity.length()>0:
			player_animated_sprite.play("Walk")
		else:
			player_animated_sprite.stop()
			player_animated_sprite.play("Stay")

#Jump functions

func _jump():
	player_animated_sprite.play("Jump")
	velocity.y = jump_velocity

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func lose_mp():
	if(shield.blocking == true or shield2.blocking == true):
		var currentMP = PLAYER_MP.get_current()
		currentMP-=shield.costo_shield
		PLAYER_MP.set_current(currentMP)

func handle_time_to_lose ():
	var ttl_timer : Timer = Timer.new()
	add_child(ttl_timer)
	ttl_timer.wait_time = 0.4
	ttl_timer.one_shot = false
	ttl_timer.timeout.connect(func() : lose_mp())
	ttl_timer.start()


func restore_mp():
	var currentMP = PLAYER_MP.get_current()
	currentMP+=shield.costo_shield
	PLAYER_MP.set_current(currentMP)

func handle_time_to_restore ():
	var ttr_timer : Timer = Timer.new()
	add_child(ttr_timer)
	ttr_timer.wait_time = 1.5
	ttr_timer.one_shot = false
	ttr_timer.timeout.connect(func() : restore_mp())
	ttr_timer.start()

func STOP():
	can_move = false

func GO():
	can_move = true


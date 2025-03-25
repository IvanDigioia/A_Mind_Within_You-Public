extends Area2D
class_name Shield


var initial_position : Vector2
var blocking  = false: set = set_blocking, get = get_blocking
var costo_shield = 20

var time_to_parry : float = 0.5
var time_shield : float = 2.0
@export var block_speed : float = 150.0
@onready var Suono_parry : AudioStreamPlayer = $"Parry"
var master_bus_parry = AudioServer.get_bus_index("Master parry")

func _ready():
	hide()
	AudioServer.set_bus_volume_db(master_bus_parry, -10.0)
	initial_position = position


func active_shield():
	if get_parent().PLAYER_MP >= costo_shield and blocking == true:
		var timer : Timer = Timer.new()
		timer.wait_time = time_shield
		timer.autostart = true
		if(timer.is_stopped()):
			get_parent().PLAYER_MP -= costo_shield
			print(get_parent().PLAYER_MP)
	elif get_parent().PLAYER_MP < costo_shield:
		set_blocking(false)
		var timer2 : Timer = Timer.new()
		timer2.wait_time = time_shield*2
		timer2.autostart = true
		if(timer2.is_stopped()):
			get_parent().PLAYER_MP += costo_shield
			print(get_parent().PLAYER_MP)

#Shield Functions

func shoot_back(attacker : Projectile, knock_back_force : Vector2 = Vector2()):
	if blocking and attacker.ray.get_collider() == self:
		var dir = Vector2(-attacker.direction.x, attacker.direction.y)
		attacker.global_rotation = dir.angle() + PI
		attacker.direction = dir
		Suono_parry.play()

func set_blocking(value : bool):
	blocking = value
	self.visible = value

func get_blocking() -> bool:
	return blocking

func _on_area_entered(area):
	if(area is Projectile):
		if(area.ray.is_colliding()):
			area.collision_layer = 1
			area.collision_mask = 1
			shoot_back(area, area.direction)
	return

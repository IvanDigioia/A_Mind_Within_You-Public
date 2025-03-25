extends Node

class_name HealthPlayer

signal max_changed(new_max)
signal changed(new_amount)
signal depleted

@export var max = 150 : set = set_Health, get = get_Health
@onready var current = max  : set = set_current, get = get_current

func _ready():
	_initialize()


func get_Health() -> int:  
	return max
	

func get_current():
	return current

func set_Health(health : int):
	max = health
	max = max(1, health)
	emit_signal("max_changed", max)

func set_current(health: int):
	current = health
	current = clamp(current, 0, max)
	emit_signal("changed", current)
	
	if(current == 0):
		emit_signal("depleted")

func _initialize():
	emit_signal("max_changed", max)
	emit_signal("changed", current)



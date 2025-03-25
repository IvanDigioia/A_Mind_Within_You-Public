extends Node

class_name ManaPlayer

signal max_changed(new_max)
signal changed(new_amount)
signal depleted

@export var max = 250 : set = set_Mana, get = get_Mana
@onready var current = max  : set = set_current, get = get_current

func _ready():
	_initialize()


func get_Mana() -> int:  
	return max
	

func get_current():
	return current

func set_Mana(mana : int):
	max = mana
	max = max(1, mana)
	emit_signal("max_changed", max)

func set_current(mana: int):
	current = mana
	current = clamp(current, 0, max)
	emit_signal("changed", current)
	
	if(current == 0):
		emit_signal("depleted")

func _initialize():
	emit_signal("max_changed", max)
	emit_signal("changed", current)

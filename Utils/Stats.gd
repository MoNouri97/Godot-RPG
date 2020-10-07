extends Node
export(int) var max_health := 1 setget set_max_health
onready var health := max_health setget set_health

signal health_reached_zero
signal health_changed
signal max_health_changed

func set_health(value:int) -> void :
	if health == value :
		return
	if value > max_health :
		return
	emit_signal("health_changed",value)
	health = value
	if health <= 0 :
		emit_signal("health_reached_zero")


func set_max_health(value:int) -> void :
	if value < 1 :
		return
	max_health = value
	if health:
		self.health = min(value,health)
	emit_signal("max_health_changed",value)

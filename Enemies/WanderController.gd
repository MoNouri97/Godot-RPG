extends Node2D

signal reached_target

onready var original_position = global_position
onready var target_position = global_position

export var wander_range := 10


func update_target_position() -> void :
	target_position = original_position +  Vector2(rand_range(-wander_range,wander_range),rand_range(-wander_range,wander_range))


func start_timer (duration:int) -> void:
	$Timer.start(duration)

func _on_Timer_timeout() -> void:
	update_target_position()
	emit_signal("reached_target")

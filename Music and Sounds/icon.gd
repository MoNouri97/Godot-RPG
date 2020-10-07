tool
extends Sprite

export var rotateA = false setget set_rotate

func set_rotate(b):
	rotateA = b
	rotation_degrees += 90

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		rotation_degrees += 90*delta
	pass

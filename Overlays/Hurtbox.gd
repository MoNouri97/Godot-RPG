extends Area2D
#singelton access
var audioManager = AudioManager

export(bool) var showHit = true
export var offset = Vector2.ZERO
var HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	if !showHit : return
	audioManager.playSfx('Hit')
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position + offset

extends Node2D

var GrassEffect:PackedScene = preload("res://Effects/GrassEffect.tscn")


func createEffect () -> void:
#		get instance of the effect
		var grassEffect:Node2D = GrassEffect.instance()
#		set the parent to be the root
		var world = get_tree().current_scene
		world.add_child(grassEffect)
#		set the position
		grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(_area):
	createEffect()
	queue_free()

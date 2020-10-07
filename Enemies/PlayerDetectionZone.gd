extends Area2D

var player:Player = null

func canSeePlayer () -> bool:
	return player != null


func _on_PlayerDetectionZone_body_entered(body: Player) -> void:
	player = body


func _on_PlayerDetectionZone_body_exited(_body: Player) -> void:
	player = null

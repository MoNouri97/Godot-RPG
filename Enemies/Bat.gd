extends KinematicBody2D
class_name Bat

#singelton access
var audioManager = AudioManager

export var ACCELARATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200


onready var stats = $Stats
onready var detectionZone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var softCollusion = $SoftCollusion
onready var wanderController = $WanderController



const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

enum { IDLE,CHASE,WANDER }
var state = WANDER


func _physics_process(delta):
#	hit detection
	knockback = knockback.move_toward(Vector2.ZERO , FRICTION * delta)
	knockback = move_and_slide(knockback)
#	state machine
	match state :
		IDLE:
			idle_state(delta)
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)


	set_orientation()
	if softCollusion.is_colliding():
		velocity += softCollusion.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)


func idle_state (delta) -> void:
	velocity = velocity.move_toward(Vector2.ZERO , FRICTION * delta)
	seek_player()


func wander_state (delta) -> void:
	var direction = global_position.direction_to(wanderController.target_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELARATION * delta)
	seek_player()

	if global_position.distance_to(wanderController.target_position) <= 4:
		state = pick_random_state([IDLE,WANDER])
		wanderController.start_timer(rand_range(1,3))


func chase_state (delta) -> void:
	var player : Player = detectionZone.player
	if !player :
		state = IDLE
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(
		MAX_SPEED * direction,
		ACCELARATION * delta)

func set_orientation () ->void :
	if velocity == Vector2.ZERO : return
	sprite.flip_h = velocity.x < 0


func seek_player():
	if detectionZone.canSeePlayer():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	knockback = area.knockbackVector * area.knockbackAmount
	stats.health -= area.damage



func _on_Stats_health_reached_zero() -> void:
	audioManager.playSfx('EnemyDie')
	queue_free()
	var deathEffect:AnimatedSprite = EnemyDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position


func _on_WanderController_reached_target() -> void:
	state = pick_random_state([IDLE,WANDER])
	wanderController.start_timer(rand_range(1,3))


func pick_random_state(states:Array) :
	return states[randi() % states.size()]

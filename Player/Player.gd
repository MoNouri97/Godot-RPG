extends KinematicBody2D
class_name Player
#singelton access
var stats = PlayerStats
var audioManager = AudioManager

enum {
	MOVE, ROLL, ATTACK
}
var state :=  MOVE


export var MAX_SPEED := 80
export var ROLL_SPEED := 100
export var ACCELARATION := 5000
export var FRICTION := 5000
export var knockback_amount := 500
# used to show the health from PlayerStats in the inspector
export var health = 10

var input_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.LEFT
var velocity : Vector2 = Vector2.ZERO

onready var animationTree : AnimationTree = $AnimationTree
onready var animationState : AnimationNodeStateMachinePlayback = animationTree.get('parameters/playback')
onready var blinkAnimPlayer = $BlinkAnimationPlayer
onready var sword : Area2D = $HitboxPivot/SowrdHitbox
onready var timer : Timer = $Timer
onready var hurtbox : CollisionShape2D = $Hurtbox/CollisionShape2D
onready var invincibilty = false setget set_invincibility

func set_invincibility (value:bool) -> void:
	hurtbox.set_deferred("disabled", value)
	invincibilty = value


func _ready() -> void:
	stats.max_health = health
	stats.health = health
	animationTree.active = true
	sword.knockbackVector = input_vector
	stats.connect("health_reached_zero",self,'queue_free')

func _physics_process(delta):
	input_vector = get_movement_input()
	update_orientation_vectors()
#	reset state after each animation
	var current = animationState.get_current_node()
	if current == 'Idle':
		state = MOVE
#	check for attack
	if (Input.is_action_just_pressed("attack") and state == MOVE):
		state = ATTACK
		audioManager.playSfx('Swipe')

#	check for roll
	if (Input.is_action_just_pressed("roll") and state == MOVE):
		state = ROLL
		audioManager.playSfx('Evade')
		enable_invincibility(0.5, false)

#	state machine
	match state :
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		ROLL:
			roll_state()


func attack_state() -> void :
	velocity = Vector2.ZERO
	animationState.travel('Attack')


func roll_state() -> void :
	velocity = roll_vector * ROLL_SPEED
	animationState.travel('Roll')
	update_velocity()


func move_state(delta:float) -> void :
	if input_vector != Vector2.ZERO:
#		update velocity var
		velocity = velocity.move_toward(input_vector * MAX_SPEED , ACCELARATION * delta)

#		change animation
		animationState.travel('Run')
	else:
		velocity = velocity.move_toward(Vector2.ZERO , FRICTION * delta)
		animationState.travel('Idle')
#	move
	update_velocity()

func update_orientation_vectors () -> void:
	if input_vector == Vector2.ZERO:
		return
	update_blend_positions()
	if state != ROLL:
		roll_vector = input_vector
	if state != ATTACK:
		sword.knockbackVector = input_vector


func update_blend_positions () -> void:
	if state != MOVE : return
	animationTree.set('parameters/Idle/blend_position',input_vector)
	animationTree.set('parameters/Run/blend_position',input_vector)
	animationTree.set('parameters/Attack/blend_position',input_vector)
	animationTree.set('parameters/Roll/blend_position',input_vector)


func update_velocity() -> void :
	velocity = move_and_slide(velocity)


func get_movement_input() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return input.normalized()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= 1
	var direction = (global_position - area.global_position).normalized()
	velocity += direction * knockback_amount
	enable_invincibility()
	audioManager.playSfx('Hurt')


func enable_invincibility(duration:float = 1,flash:bool=true) -> void:
	self.invincibilty = true
	if flash :
		blinkAnimPlayer.play("Start")

	if duration == 0:
		return
	timer.connect("timeout",self,'disable_invincibility')
	timer.start(duration)


func disable_invincibility () -> void:
	self.invincibilty = false
	blinkAnimPlayer.play("Stop")
	timer.disconnect("timeout",self,'disable_invincibility')

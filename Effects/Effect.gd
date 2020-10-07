extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	play('default')
	self.connect("animation_finished",self,"_on_animation_finished")


func _on_animation_finished():
	queue_free()

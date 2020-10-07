extends Control

onready var stats = PlayerStats
onready var hearts = stats.health setget set_hearts
onready var max_hearts = stats.max_health setget set_max_hearts
onready var hear_ui_full = $HeartsFull
onready var hear_ui_empty = $HeartsEmpty

func _ready() -> void:
	self.hearts = stats.health
	self.max_hearts = stats.max_health
	stats.connect("health_changed",self,"set_hearts")
	stats.connect("max_health_changed",self,"set_max_hearts")


func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	if hear_ui_full :
		hear_ui_full.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value,1)
	if hear_ui_empty :
		hear_ui_empty.rect_size.x = max_hearts * 15

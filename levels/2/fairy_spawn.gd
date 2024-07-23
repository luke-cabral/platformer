extends Area2D

@onready var timer: Timer = $Timer
@onready var zero = $".."
@onready var arm = $"../Thorne/arm"
var fairy_scene = load("res://characters/baddies/fairy/fairy.tscn")

func _ready():
	timer.timeout.connect(spawn)

func attack(body):
	timer.start()
	arm.searchzone = 13
	
func relax(body):
	timer.stop()
	arm.searchzone = 10
	
func spawn():
	var new_fairy = fairy_scene.instantiate()
	zero.add_child(new_fairy)
	timer.wait_time = randf_range(1.3, 2.75)
	

extends Area2D

@onready var timer: Timer = $Timer
@onready var zero = $".."
var fairy_scene = load("res://characters/baddies/fairy/fairy.tscn")

func _ready():
	timer.timeout.connect(spawn)

func attack(body):
	timer.start()
	
func relax(body):
	timer.stop()
	
func spawn():
	var new_fairy = fairy_scene.instantiate()
	zero.add_child(new_fairy)
	timer.wait_time = randf_range(1.4, 2.25)
	

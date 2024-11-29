extends RigidBody2D

@export var log: CharacterBody2D
@export var force_magnitude = 500
@export var apply_interval = 0.25
@export var xmin: int = 740
@export var xmax: int = 841
@export var ymin: int = 740
@export var ymax: int = 841

var start = Vector2(1,1)
var timer = 0.0

func _ready():
	start = global_position
	randomize()
	
func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		apply_random_impulse()
		timer = apply_interval
	if global_position.x < xmin or global_position.x > xmax or global_position.y < ymin or global_position.y > ymax:
		global_position = start

func apply_random_impulse():
	var angle = randf() * 2 * PI
	var direction = Vector2(cos(angle), sin(angle))
	apply_central_impulse(direction * force_magnitude)

func crack(area):
	log.activate()
	queue_free()

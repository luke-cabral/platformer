extends RigidBody2D

@onready var log = $"../log"
@export var force_magnitude = 500  # Adjust the force magnitude as needed
@export var apply_interval = 0.25  # Time interval to apply the force
var start = Vector2(1,1)

var timer = 0.0

func _ready():
	randomize()  # Ensure randomness
	start = global_position
	
func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		apply_random_impulse()
		timer = apply_interval
	if abs(global_position.x - start.x) > 555 or abs(global_position.y - start.y) > 555:
		global_position = start

func apply_random_impulse():
  	# Generate a random direction
	var angle = randf() * 2 * PI
	var direction = Vector2(cos(angle), sin(angle))
	apply_central_impulse(direction * force_magnitude)

func crack(area):
	log.activate()
	queue_free()

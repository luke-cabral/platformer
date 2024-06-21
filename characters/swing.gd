extends state

@onready var thorne: CharacterBody2D = $".."
@onready var thornesee: AnimatedSprite2D = $"../thornesee"
@onready var arm: AnimatedSprite2D = $"../arm"
@onready var hand: AnimatedSprite2D = $"../arm/hand"
@onready var reach: RayCast2D = $"../arm/hand/wrist/reach"
@onready var grounded: state = $"../grounded"
@export var max_swing_speed: float = 5000.0
@export var acceleration: float = 2700.0
@export var deceleration: float = 2800.0
@export var speedup: float = 1.15
var arc: float = 256.0
var swing_speed: float = 0
var distance: float = arc
var east: bool = true
var swing_direction := Vector2.RIGHT

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("grapple"):
		arm.reset()
		stop(grounded)
		
	if Input.is_action_just_pressed("jump"):
		arm.reset()
		grounded.coyote_counter = 5
		grounded.jump_buffer_counter = 5
		stop(grounded)
		
	var direction_to_center: Vector2 = (arm.anchor_point - thorne.global_position).normalized()
	if !east:
		swing_direction = direction_to_center.rotated(PI / 2)
	else:
		swing_direction = direction_to_center.rotated(-PI / 2)
		
	var should_accelerate: bool = swing_direction.y > 0
	
	if should_accelerate:
		swing_speed = min(thorne.velocity.length() + acceleration * delta, max_swing_speed)
	else:
		swing_speed = thorne.velocity.length() - deceleration * delta
		if swing_speed < 0:
			east = !east
			swing_speed = thorne.velocity.length() + acceleration * delta * 2.5
			swing_direction = swing_direction.rotated(PI)

	thorne.velocity = swing_direction.normalized() * swing_speed * speedup
	
	thorne.move_and_slide()
	
	thornesee.flip_h = swing_direction.x < 0
	
	arm.adjust()
	
	distance = thorne.global_position.distance_to(arm.anchor_point)
	if distance != arc:
		var direction_to_thorne: Vector2 = (thorne.global_position - arm.anchor_point).normalized()
		thorne.global_position = arm.anchor_point + direction_to_thorne * arc
	
	if thorne.is_on_floor():
		stop(grounded)
		
	arm.adjust()

func update(length: float) -> void:
	arc = length
	east = thorne.velocity.x < 0
	thornesee.flip_h = east
	thorne.velocity.y = 0
	
func flip():
	east = !east
	thorne.velocity = Vector2.ZERO

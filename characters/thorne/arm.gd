extends AnimatedSprite2D

@onready var thorne = $".."
@onready var thornesee = $"../thornesee"
@onready var grounded = $"../grounded"
@onready var hand = $hand
@onready var handx = $hand/handx
@onready var wrist = $hand/wrist
@onready var reach = $hand/wrist/reach
@onready var slice = $slash
@onready var attackt = $attack
@onready var slashhb = $slash/slashhb
@onready var swing = $"../swing"

@export var grow_speed = 0.2
@export var max_length = 2
@export var searchzone: int = 10

var shooting = false
var anchor = false
var shrink = false
var busy = false
var moving_anchor = false
var anchor_point = Vector2.ZERO
var wall_angle = Vector2.RIGHT
var x = 1
var anchor_to_wall = Vector2(1, 1)
var wall = 1

func _ready():
	slashed()

func _process(delta):
	if anchor or shooting:
		handx.monitorable = true
		busy = true
	else:
		handx.monitorable = false
	
	if shrink:
		scale.x -= grow_speed
		stable()
		if scale.x < .075:
			busy = false
			hand.play("punch")
			visible = false
			shrink = false
			rotation = 0
			hand.rotation = 0
	elif shooting and !anchor:
		aim()
	elif Input.is_action_just_pressed("slash") and !busy:
		slash()
		attackt.start()
	if !attackt.is_stopped():
		x = x + 1
		if thornesee.flip_h:
			flip_h = false
			position.x = -179
			slashhb.position.x = 90
		else:
			flip_h = true
			position.x = -161
			slashhb.position.x = 165
		
func reset():
	anchor = false
	shooting = false
	shrink = true
	moving_anchor = false
	
func adjust() -> void:
	hand.global_position = anchor_point
	var direction = anchor_point - global_position
	rotation = direction.angle()
	var distance = global_position.distance_to(anchor_point)
	scale.x = distance / 256
	stable()
	hand.global_position = anchor_point
	
func stable() -> void:
	hand.scale.x = .3 / scale.x
	wrist.scale.x = 1
	
func aim():
	if knuckle():
		impact()
		return
	for x in range(1, searchzone + 1):
		wrist.rotate(PI/90 * x)
		reach.force_raycast_update()
		if knuckle():
			shoulder(reach.get_collision_point())
			wrist.rotation = 0
			reach.force_raycast_update()
			impact()
			return
		else:
			wrist.rotate(-PI/45 * x)
			reach.force_raycast_update()
			if knuckle():
				shoulder(reach.get_collision_point())
				wrist.rotation = 0
				reach.force_raycast_update()
				impact()
				return
		wrist.rotation = 0
	stretch()
	
func _physics_process(delta):
	if moving_anchor:
		anchor_point = wall.global_position + anchor_to_wall
		adjust()
	
func knuckle() -> bool:
	if reach.is_colliding():
		var distance = reach.get_collision_point().distance_to(reach.global_position)
		return(distance < grow_speed * 256)
	else:
		return(false)

func impact():
	var collider = reach.get_collider()
	if !collider:
		return
		
	if collider.is_in_group("wall"):
		reach.position.x = 34
	var distance = reach.get_collision_point().distance_to(reach.global_position)
	reach.position.x = 75
	scale.x += distance / .512 * .002
	stable()
	
	if collider.is_in_group("bad"):
		collider.hit()
		reset()
	elif collider.is_in_group("wall"):
		wall_angle = reach.get_collision_normal()
		anchor_point = hand.global_position
		if collider.is_in_group("move"):
			print(anchor_point, collider.global_position)
			anchor_to_wall = anchor_point - collider.global_position
			wall = collider
			moving_anchor = true
			print(anchor_to_wall)
		anchor = true
		shooting = false
		hand.play("swing")
		if Global.radian:
			swing.update(256 * scale.x)
			grounded.stop(swing)
		
func stretch() -> void:
	scale.x += grow_speed
	stable()
	if scale.x > max_length:
		reset()

func shoulder(target) -> void:
	var direction = target - global_position
	rotation = direction.angle()
	
func slash():
	busy = true
	hand.visible = false
	visible = true
	scale = Vector2(1.3, 0.61)
	position.y = 5
	slashhb.position.y = 47
	play("slash")
	slice.monitoring = true
	slice.monitorable = true
	
func slashed():
	position = Vector2(0, 12)
	play("grapple")
	visible = false
	hand.visible = true
	flip_h = false
	busy = false
	scale = Vector2(.075, 0.29)
	slice.monitoring = false
	slice.monitorable = false
	
func attack(body):
	if body.is_in_group("bad"):
		body.hit()
		thorne.velocity.y -= 400
		grounded.flinch = 4

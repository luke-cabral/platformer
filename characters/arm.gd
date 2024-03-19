extends Sprite2D

@onready var hand = $hand
@onready var wrist = $hand/wrist
@onready var reach = $hand/wrist/reach
@export var grow_speed = 0.2
@export var max_length = 2
@export var searchzone = 10
var shooting = false
var anchor = false
var shrink = false
var busy = false
var anchor_point = Vector2.ZERO
var wall_angle = Vector2.RIGHT

func _process(delta):
	if anchor or shooting:
		busy = true
	
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
		
func reset():
	anchor = false
	shooting = false
	shrink = true
	
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
	
func knuckle() -> bool:
	if reach.is_colliding():
		var distance = reach.get_collision_point().distance_to(reach.global_position)
		return(distance < grow_speed * 256)
	else:
		return(false)

func impact():
	var collider = reach.get_collider()
	if !collider:
		aim()
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
		anchor = true
		shooting = false
		hand.play("swing")
		
func stretch() -> void:
	scale.x += grow_speed
	stable()
	if scale.x > max_length:
		reset()

func shoulder(target) -> void:
	var direction = target - global_position
	rotation = direction.angle()

	

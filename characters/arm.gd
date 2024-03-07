extends Sprite2D

@onready var hand = $hand
@onready var reach = $hand/reach
@export var grow_speed = 0.2
@export var max_length = 2
var shooting = false
var anchor = false
var shrink = false
var anchor_point = Vector2.ZERO
var wall_angle = Vector2.RIGHT

func _process(delta):
	if shrink:
		scale.x -= grow_speed
		hand.scale.x = .3 / scale.x
		if scale.x < .075:
			hand.play("punch")
			visible = false
			shrink = false
			rotation = 0
			hand.rotation = 0
	elif shooting and !anchor:
		reach.force_raycast_update()
		if reach.is_colliding():
			var collider = reach.get_collider()
			var where = reach.get_collision_point()
			var where2 = where.distance_to(reach.global_position)
			if where2 < grow_speed * 256:
				if collider.is_in_group("wall"):
					reach.position.x = 34
					reach.force_raycast_update()
					where = reach.get_collision_point()
					where2 = where.distance_to(reach.global_position)
					reach.position.x = 75
				scale.x += where2 / .512 * .002
				hand.scale.x = .3 / scale.x
				if collider.is_in_group("bad"):
					collider.hit()
					reset()
				elif collider.is_in_group("wall"):
					wall_angle = reach.get_collision_normal()
					print(wall_angle)
					anchor_point = hand.global_position
					anchor = true
					shooting = false
					hand.play("swing")
					hand.rotation = wall_angle.rotated(PI).angle()
			else:
				scale.x += grow_speed
				hand.scale.x = .3 / scale.x
				if scale.x > max_length:
					reset()
		else:
			scale.x += grow_speed
			hand.scale.x = .3 / scale.x
			if scale.x > 2:
				reset()
	elif anchor:
		pass
		
func reset():
	anchor = false
	shooting = false
	shrink = true
	
func adjust():
	hand.global_position = anchor_point
	var direction = anchor_point - global_position
	rotation = direction.angle()
	var distance = global_position.distance_to(anchor_point)
	scale.x = distance / 256
	hand.scale.x = .3 / scale.x
	hand.global_position = anchor_point
	


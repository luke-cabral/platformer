extends state

@onready var thorne = $".."
@onready var thornesee = $"../thornesee"
@onready var arm = $"../arm"
@onready var hand = $"../arm/hand"
@onready var reach = $"../arm/hand/wrist/reach"
@onready var body = $"../body"
@onready var swing = $"../swing"
@onready var wall = $"../wall"
@onready var butler = $butler
@onready var max_stretch = 256 * arm.max_length + 50
@onready var ray_space = body.shape.height/150

@export var max_speed: int = 900
@export var gravity: float = 55
@export var jump_force: int = 1500
@export var jump_buffer_time: int = 15
@export var coyote_time: int = 15
@export var fall_speed: int = 2000
@export var pull_speed: int = 2345
@export var wall_leeway = 33

var startpoint = Vector2.ZERO
var endpoint = Vector2.ZERO
var coyote_counter: int = 0
var jump_buffer_counter: int = 0
var prep_swing: int = 20
var prepping : int =  0
var loadstate: bool = false
var pull : bool = false
var direction := Vector2.RIGHT
var bypass_movement: bool = false
var flinch : int = 0
var flincheast: bool = true 

func _ready():
	start()

func _physics_process(delta):
	
	if not thorne.is_on_floor():
		thorne.velocity.y += gravity
		coyote_counter -= 1
		if thorne.velocity.y > fall_speed:
			thorne.velocity.y = fall_speed
			
	if Input.is_action_pressed("ui_right"):
		thorne.velocity.x = max_speed
		thornesee.flip_h = false
		if thorne.is_on_floor():
			thornesee.offset.x = 50
		else:
			thornesee.offset.x = 10
		if thorne.is_on_floor():
			if arm.busy:
				thorne.see.play("run noarm")
			else:
				thorne.see.play("run")
	elif Input.is_action_pressed("ui_left"):
		thorne.velocity.x = - max_speed
		if thorne.is_on_floor():
			thornesee.offset.x = -60
		else:
			thornesee.offset.x = -20
		thornesee.flip_h = true
		if thorne.is_on_floor():
			if arm.busy:
				thorne.see.play("run noarm")
			else:
				thorne.see.play("run")
	else:
		thorne.velocity.x = 0
		if thorne.is_on_floor():
			if arm.busy:
				thorne.see.play("still noarm")
			else:
				thorne.see.play("still")
	
	thorne.velocity.x = clamp(thorne.velocity.x, -max_speed, max_speed)	
	
	if flinch > 0:
		if thornesee.flip_h:
			thorne.velocity.x = 1200
		else:
			thorne.velocity.x = -1200
		flinch -= 1
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
			
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
		
	if thorne.is_on_floor():
		coyote_counter = coyote_time	
			
	if jump_buffer_counter > 0 and coyote_counter > 0:
		thorne.velocity.y -= jump_force
		jump_buffer_counter = 0
		coyote_counter = 0
		if arm.busy:
			thorne.see.play("jump noarm")
		else:
			thorne.see.play("jump")
		if arm.anchor:
			prepping = prep_swing
		
	if Input.is_action_just_released("jump"):
		if thorne.velocity.y < -123:
			thorne.velocity.y += 700
			
#region swing
	if Global.radian:
		if Input.is_action_just_pressed("swing"):
			if !thorne.is_on_floor() and arm.anchor:
				swing.update(256 * arm.scale.x)
				stop(swing)
				
		if loadstate:
			if !arm.anchor:
				loadstate = false
			elif thorne.velocity.y >= 0:
				loadstate = false
				swing.update(256 * arm.scale.x)
				stop(swing)
			
		if prepping > 0:
			prepping -= 1
			if prepping == 0:
				loadstate = true
#endregion
			
#region wall climb
	if Global.glue:
		if thorne.is_on_wall() and !arm.anchor and !thorne.is_on_floor():
			var collision = thorne.move_and_collide(thorne.velocity * delta)
			if collision:
				collision = collision.get_normal()
				if acceptable(collision):
					arm.wall_angle = collision
					arm.reset()
					pull = false
					body.rotation_degrees = 0
					stop(wall)
#endregion
	
#region grapple
	if Global.rubber:
		if Input.is_action_just_pressed("grapple"):
			if !arm.shooting and !arm.anchor:
				var deadzone = 0.5
				var controllerangle = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1)).angle()
				var xAxis = Input.get_joy_axis(0, 2)
				var yAxis = Input.get_joy_axis(0 ,3)
				if abs(xAxis) > deadzone || abs(yAxis) > deadzone:
					controllerangle = Vector2(xAxis, yAxis).angle()
				arm.visible = true
				arm.rotation = controllerangle
				arm.shooting = true
			elif arm.anchor:
				arm.reset()
				
		if Input.is_action_just_released("grapple"):
			if arm.shooting:
				hand.play("punch")
				arm.reset()
			else:
				suitable()
#endregion
			
#region anchored and pulling
	if Input.is_action_just_pressed("pull"):
		if arm.anchor and Global.hook:
			pull = true
			direction = Vector2.RIGHT.rotated(arm.rotation)
			body.rotation_degrees = 0
			
	if pull:
		var distance = thorne.global_position.distance_to(hand.global_position)
		var potential_movement = pull_speed * delta
		if distance > potential_movement:
			thorne.velocity = direction * pull_speed
			arm.scale.x -= potential_movement / 256
		else:
			thorne.velocity = direction * pull_speed * 1.05
			arm.scale.x -= potential_movement / 256
			arm.reset()
			pull = false
			body.rotation_degrees = 0
			if suitable():
				thorne.move_and_slide()
				stop(wall)
	elif arm.anchor:
		arm.adjust()
		var potential_new_position = thorne.global_position + thorne.velocity * delta
		var direction_to_anchor_point = potential_new_position - arm.anchor_point
		var distance_to_anchor_point = direction_to_anchor_point.length()
		
		if distance_to_anchor_point > (max_stretch):
			if potential_new_position.y > arm.anchor_point.y + max_stretch:
				thorne.velocity.y = (arm.anchor_point.y + max_stretch - thorne.global_position.y) / delta
			elif potential_new_position.y < arm.anchor_point.y - max_stretch:
				thorne.velocity.y = (arm.anchor_point.y - max_stretch - thorne.global_position.y) / delta
			direction_to_anchor_point = thorne.global_position + thorne.velocity * delta - arm.anchor_point
			var clamped_direction = direction_to_anchor_point.normalized() * (max_stretch)
			var clamped_position = arm.anchor_point + clamped_direction
			thorne.velocity.x = (clamped_position.x - thorne.global_position.x) / delta
#endregion
			
	thorne.move_and_slide()
		
	if arm.anchor:
		arm.adjust()
		
func suitable() -> bool:
	butler.rotation = arm.wall_angle.angle() + PI/2
	butler.global_position = arm.anchor_point + (body.shape.height - 2 * wall_leeway) / 2 * arm.wall_angle.rotated(PI/2) + 25 * arm.wall_angle
	butler.force_raycast_update()
	if butler.get_collider() == null:
		return false
	var distance = butler.get_collision_point().distance_to(butler.global_position)
	for scrutiny in range(1 + wall_leeway, 151 - wall_leeway):
		butler.global_position = butler.global_position + ray_space * arm.wall_angle.rotated(-PI/2)
		butler.force_raycast_update()
		if butler.get_collider() == null:
			return false
		elif !butler.get_collider().is_in_group("wall"):
			return false
		elif floor(butler.get_collision_point().distance_to(butler.global_position)) != floor(distance):
			return false
	return true
	
func acceptable(collision) -> bool:
	butler.rotation = collision.angle() + PI/2
	butler.global_position = global_position + Vector2(0, 25) + (body.shape.height - 2 * wall_leeway) / 2 * collision.rotated(PI/2)# + 25 * collision
	butler.force_raycast_update()
	if butler.get_collider() == null:
		return false
	var distance = butler.get_collision_point().distance_to(butler.global_position)
	for scrutiny in range(1 + wall_leeway, 151 - wall_leeway):
		butler.global_position = butler.global_position + ray_space * collision.rotated(-PI/2)
		butler.force_raycast_update()
		if butler.get_collider() == null:
			return false
		elif !butler.get_collider().is_in_group("wall"):
			return false
		elif floor(butler.get_collision_point().distance_to(butler.global_position)) != floor(distance):
			return false
	return true
	

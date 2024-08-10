extends CharacterBody2D

@onready var detection_shape = $Detection/DetectionShape
@onready var sprite = $AnimatedSprite2D
@export var speed = 500
@export var health = 3
@export var gravity = 60
@export var detection_size: float = 1.0
var flinch = 0
var spotted: bool = false
var east : bool = false
signal success()

func _ready():
	detection_shape.scale *= detection_size
	
func _physics_process(delta):
	if spotted:
		if east:
			velocity.x = speed
			sprite.flip_h = false
		else:
			velocity.x = -speed
			sprite.flip_h = true
	else:
		velocity.x = 0
			
	if is_on_floor() and flinch == 0:
		velocity.y = 0
	else:
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
			
	if flinch > 0:
		velocity.x = flinch * 120
		if !sprite.flip_h:
			velocity.x *= -1
		flinch -= 1
	
	move_and_slide()
	
func navigate(thornex):
	east = (thornex - global_position.x) > 0
	
func hit():
	velocity.y = -800
	flinch = 16
	sprite.play("hit")
	health -= 1
	if health < 1:
		success.emit()
		queue_free()

func hitover():
	sprite.play("attack!")
	
func detected(who):
	print(who, who.get_groups())
	if who.is_in_group("thorne"):
		spotted = true
		sprite.play("attack!")
	
func escaped(who):
	if who.is_in_group("thorne"):
		spotted = false
		sprite.stop()

	

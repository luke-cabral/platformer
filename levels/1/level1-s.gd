extends Node2D

@onready var boss = $"visuals/0/boss"
@onready var thorne = $"visuals/0/Thorne"
@onready var grounded = $"visuals/0/Thorne/grounded"
@onready var thornesee: AnimatedSprite2D = $"visuals/0/Thorne/thornesee"
var land: Vector2 = Vector2(1050, 60)
var wet: bool = false

func _ready():
	boss.success.connect(onward)
	
func onward():
	var gandolf = Timer.new()
	add_child(gandolf)
	gandolf.wait_time = 1.6
	gandolf.start()
	gandolf.timeout.connect(SceneMaster.change_scene.bind("res://levels/2/level_2.tscn"))
	Global.rubber = true
	
func wet1(body):
	land = Vector2(1050, 60)
	thorne.position.y = 390
	splash()
	
func wet2(body):
	land = Vector2(1910, 200)
	thorne.position.y = 360
	splash()
	
func wet3(body):
	land = Vector2(5614, 60)
	thorne.position.y = 510
	splash()
	
func splash():
	grounded.set_physics_process(false)
	thornesee.flip_h = false
	thorne.rotate(-PI/2)
	thorne.velocity = Vector2(-25, 0)
	wet = true
	
func _physics_process(delta):
	if wet:
		thornesee.play("still")
		thorne.velocity.x -= 60
		if thorne.velocity.x < -3600:
			thorne.velocity.x = -3600
		if thorne.position.x < land.x:
			thorne.velocity.x = 0
			thorne.position = Vector2(land.x - 70, land.y)
			thorne.rotation = 0
			grounded.set_physics_process(true)
			wet = false
		else:
			thorne.move_and_slide()

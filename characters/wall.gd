extends state

@onready var thorne := $".."
@onready var thornesee := $"../thornesee"
@onready var grounded: state = $"../grounded"

func start():
	super.start()
	thornesee.play("wall")
	thornesee.scale = Vector2(0.38, 0.38)
	thornesee.offset = Vector2(-279, 60)
	thornesee.rotation_degrees = -1
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		thornesee.scale = Vector2(0.2, 0.2)
		thornesee.rotation_degrees = 0
		thornesee.play("jump")
		thorne.velocity.y -= grounded.jump_force
		grounded.jump_buffer_counter = 0
		grounded.coyote_counter = 0
		stop(grounded)
	

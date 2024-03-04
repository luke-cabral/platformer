extends state

@onready var thorne := $".."
@onready var thornesee := $"../thornesee"
@onready var grounded: state = $"../grounded"

func start():
	super.start()
	thornesee.play("wall")
	thornesee.scale.x = 0.35
	thornesee.scale.y = 0.35
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		thornesee.scale.x = 0.2
		thornesee.scale.y = 0.2
		thornesee.play("jump")
		thorne.velocity.y -= grounded.jump_force
		grounded.jump_buffer_counter = 0
		grounded.coyote_counter = 0
		stop(grounded)
	

class_name state
extends Node

func _ready():
	set_physics_process(false)

func start():
	set_physics_process(true)
	
func stop(new_state):
	set_physics_process(false)
	new_state.start()

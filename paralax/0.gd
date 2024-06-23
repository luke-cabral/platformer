extends CanvasLayer

@onready var cam := $Thorne/Cam
@onready var thorne := $Thorne
var enemiestx = []
var spawn: Vector2 = Vector2(0,0)

func _ready():
	for child in get_tree().get_nodes_in_group("trackx"):
		enemiestx.append(child)
	spawn = thorne.position
		
func _process(delta):
	for enemy in enemiestx:
		if !enemy:
			enemiestx.erase(enemy)
		else:
			enemy.navigate(thorne.global_position.x)
			
func dead():
	cam.set_process(false)
	thorne.set_process(false)
	var think = Timer.new()
	add_child(think)
	think.wait_time = 0.65
	think.start()
	think.timeout.connect(alive)
	think.timeout.connect(think.queue_free)
	
func alive():
	thorne.position = spawn
	cam.position = spawn
	thorne.set_process(true)
	cam.set_process(true)
	
func update_spawn(place):
	spawn = place
	

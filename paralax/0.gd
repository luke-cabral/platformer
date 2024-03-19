extends CanvasLayer

@onready var thorne := $Thorne
var enemiestx = []

func _ready():
	for child in get_tree().get_nodes_in_group("trackx"):
		enemiestx.append(child)
		
func _process(delta):
	for enemy in enemiestx:
		if !enemy:
			enemiestx.erase(enemy)
		else:
			enemy.navigate(thorne.global_position.x)

extends AudioStreamPlayer
@onready var player = $"."

func _ready():
	player.connect("finished", Callable(self,"loop").bind(player))
	player.play()

func loop(player):
	player.stream_paused = false

extends Node2D

@onready var boss = $"visuals/0/boss"

func _ready():
	boss.success.connect(onward)
	
func onward():
	var gandolf = Timer.new()
	add_child(gandolf)
	gandolf.wait_time = 1.6
	gandolf.timeout.connect(SceneMaster.change_scene.bind("res://levels/2/level_2.tscn"))
	Global.rubber = true

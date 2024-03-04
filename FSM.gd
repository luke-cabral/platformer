class_name FSM
extends Node

var starter: Node = null
var current: Node = starter

func transition(old, new):
	old.stop()
	new.start()

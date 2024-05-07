extends Node
@onready var cam = %Cam

func say_cheese():
	cam.size = 
	var image = get_viewport().get_texture().get_image()
	var album = Time.get_time_dict_from_system()
	print("%02d:%02d:%02d" % [album.hour, album.minute, album.second] + ".png")
	image.save_png("C:/Users/lukec/Box/art/primo/snaps/" + "%02d%02d%04d" % [album.hour, album.minute, album.second] + ".png")



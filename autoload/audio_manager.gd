extends Node3D

func _process(_delta):
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()

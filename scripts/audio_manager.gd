extends Node


func play(sound: AudioStream) -> void:
	var player = AudioStreamPlayer2D.new()
	player.stream = sound
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

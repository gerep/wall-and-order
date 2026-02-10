extends Node


func play(sound: AudioStream, volume: float = 0.0) -> void:
	var player = AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = volume
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

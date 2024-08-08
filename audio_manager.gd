class_name AudioManager

extends Node2D


enum Sound {
	GRASS_STEP,
	RUSTLE,
}

var sounds: Array[AudioStreamWav] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioStreamWav.new()
	pass # Replace with function body.


func play_sound()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

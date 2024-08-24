extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var elapsed := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	elapsed += dt
	if elapsed > 1.0:
		DisplayServer.window_set_title("TGC - %d" % Engine.get_frames_per_second())
		elapsed = 0

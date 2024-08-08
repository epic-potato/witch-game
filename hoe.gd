class_name Hoe

extends Sprite2D

enum State { SWING, RESET, READY }

var state = State.READY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func swing():
	if state == State.READY:
		state = State.SWING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	var swing_angle = scale.x * -90

	match state:
		State.SWING:
			rotation_degrees = lerpf(rotation_degrees, swing_angle, dt * 20)
			if Util.is_close(rotation_degrees, swing_angle, 0.5):
				state = State.RESET
		State.RESET:
			rotation_degrees = lerpf(rotation_degrees, 0, dt * 10)
			if Util.is_close(rotation_degrees, 0, 0.5):
				state = State.READY


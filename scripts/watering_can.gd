class_name WateringCan

extends AnimatedSprite2D

enum State { USE, RESET, READY }

const WATERING_TIME: float = 1

var state = State.READY
var time_left: float = WATERING_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func use():
	if state == State.READY:
		state = State.USE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	var angle = scale.x * -45

	match state:
		State.USE:
			rotation_degrees = lerpf(rotation_degrees, angle, dt * 10)

			if Util.is_close(rotation_degrees, angle, 0.5):
				if time_left > 0:
					time_left -= dt
				else:
					state = State.RESET
					time_left = WATERING_TIME
		State.RESET:
			rotation_degrees = lerpf(rotation_degrees, 0, dt * 10)
			if Util.is_close(rotation_degrees, 0, 0.5):
				state = State.READY

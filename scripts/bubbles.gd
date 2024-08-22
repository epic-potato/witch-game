extends Node2D


var brew := false
var bubbles: Array[Bubble] = []
var orig_bubble_positions: Array[Vector2] = []


func _ready() -> void:
	var children := get_children()

	for child in children:
		if child is Bubble:
			bubbles.append(child as Bubble)
			orig_bubble_positions.append(child.position)


func _process(dt: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		brew = true

	if brew:
		var finished_count := 0

		for i in range(bubbles.size()):
			var bubble = bubbles[i]
			bubble.selected = true  # hack to get bubbles to stop moving independently

			if bubble.visible:
				bubble.position.x = lerpf(bubble.position.x, 0, dt * 6)
				bubble.position.y = lerpf(bubble.position.y, 0, dt * 3)

			if bubble.position.distance_to(Vector2.ZERO) < 3:
				bubble.visible = false
				bubble.position = orig_bubble_positions[i]

			if !bubble.visible:
				finished_count += 1

		if finished_count == bubbles.size():
			brew = false

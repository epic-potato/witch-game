extends Node2D


@export var target: Vector2

var brew := false
var bubbles: Array[Bubble] = []


func _ready() -> void:
	var children = get_children()

	for child in children:
		if child is Bubble:
			bubbles.append(child as Bubble)


func _process(dt: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		brew = true

	if brew:
		for bubble in bubbles:
			bubble.global_position.x = lerpf(bubble.global_position.x, global_position.x + target.x, dt * 6)
			bubble.global_position.y = lerpf(bubble.global_position.y, global_position.y + target.y, dt)

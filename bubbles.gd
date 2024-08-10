extends Node2D


var brew := false
var bubbles: Array[Bubble] = []
var followers: Array[PathFollow2D] = []


func _ready() -> void:
	var path_children = get_node("path").get_children()

	for follower in path_children:
		followers.append(follower)
		var bubble = follower.get_node("bubble")
		if bubble is Bubble:
			bubbles.append(bubble)


func _process(dt: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		brew = true

	if brew:
		for follower in followers:
			follower.progress += dt * 300

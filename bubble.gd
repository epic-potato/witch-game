class_name Bubble

extends Area2D


@export var offset := -4
@export var transition_time := 2.0
@export var jitter := 0.8

@onready var origin := position
@onready var target := origin.y + offset
@onready var applied_jitter := randf_range(0.2, jitter)

var selected := false
var clicked := false
var progress = 0

func _process(dt: float) -> void:
	if clicked:
		get_parent().set_progress(progress)
		progress += dt * 200
		return

	if selected:
		if Input.is_action_pressed("use"):
			clicked = true
		return

	position.y = lerpf(position.y, target, dt * transition_time)
	if Util.is_close(position.y, target, applied_jitter):
		applied_jitter = randf_range(0.1, jitter)
		if target == origin.y:
			target = origin.y + offset
		else:
			target = origin.y


func _on_mouse_entered() -> void:
	selected = true


func _on_mouse_exited() -> void:
	selected = false

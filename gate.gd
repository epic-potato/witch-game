extends Area2D


@export var scene: Game.Scene

var player_in_range: bool = false

func _ready() -> void:
	assert(scene != null, "Gate must have a transition scene")


func switch_scene(body: Node2D):
	var player = body as Player
	var dir = global_position - body.global_position
	player.global_position += dir.normalized() * 100
	game.switch_scene(scene)

func _on_body_entered(body: Node2D):
	if body is Player:
		player_in_range = true

func _on_body_exited(body: Node2D):
	if body is Player:
		player_in_range = false


func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("action") and player_in_range:
		game.switch_scene(scene)

class_name Spawner

extends Node2D


@export var scene: PackedScene
@export var max_distance: float
@export var rate: float = 10 # per minute

var rng: RandomNumberGenerator
var elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(scene != null, "Spawner must have a scene to spawn")
	rng = RandomNumberGenerator.new()
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	elapsed += dt
	if elapsed >= 1:
		elapsed = 0

		var result := rng.randi_range(0, int(60 / rate))
		if result == 1:
			var new_scene = scene.instantiate()
			new_scene.position += Vector2(rng.randf_range(-max_distance, max_distance), rng.randf_range(-max_distance, max_distance))
			add_child(new_scene)


extends Camera2D


@export var target_dimensions: Vector2i = Vector2i(1920 / 2, 1080 /2)

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = get_viewport_rect().size / Vector2(target_dimensions)
	print("Viewport:")
	print(get_viewport_rect().size)

	print("Target:")
	print(target_dimensions)

	print("ZOOM:")
	print(zoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt) -> void:
	pass


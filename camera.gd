extends Camera2D


@export var target_dimensions: Vector2i = Vector2i(1280, 720)

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = get_viewport_rect().size / Vector2(target_dimensions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt) -> void:
	pass


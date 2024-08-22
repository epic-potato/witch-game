extends Node2D

var active_type: Game.Type = Game.Type.NONE
var active_item: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt: float) -> void:
	var new_type := game.bag.get_active_item()
	if active_type == new_type:
		return
	active_type = new_type
	if active_item != null:
		active_item.queue_free()

	if new_type == Game.Type.NONE:
		active_item = null
		return
	active_item = game.get_item(active_type)
	add_child(active_item)
	active_item.scale = Vector2(4, 4)
	if active_item is Plant:
		var plant = active_item as Plant
		plant.set_frame(3)

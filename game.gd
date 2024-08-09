class_name Game

extends Node

enum Type {
	# tools
	HOE,
	WATERING_CAN,

	# foraged
	RED_CAP,
	CHAMOMILE,
	BLUE_CRYSTAL,
	PURPLE_CRYSTAL,

	# crops
	GARLIC,
	TOMATO,
	NONE,
}

func type_to_str(type: Type) -> String:
	match type:
		Type.RED_CAP:
			return "red_cap"
		Type.GARLIC:
			return "garlic"
		Type.TOMATO:
			return "tomato"
		_:
			return "unknown"

var scene: Node2D
var farm: Farm
var bag: Bag = Bag.make(10, 5)

class Item:
	var type: Type
	var scene: PackedScene

	static func init(_type: Type, _scene: PackedScene) -> Item:
		var item = Item.new()
		item.type = _type
		item.scene = _scene
		return item

var items: Array[Item] = []

func _ready() -> void:
	items.resize(Type.NONE)
	# tools
	items[Type.HOE] = Item.init(Type.HOE, preload("res://entities/hoe.tscn"))
	items[Type.WATERING_CAN] = Item.init(Type.WATERING_CAN, preload("res://entities/watering_can.tscn"))

	# foraged
	items[Type.RED_CAP] = Item.init(Type.RED_CAP, preload("res://entities/foraged/red_cap.tscn"))
	items[Type.CHAMOMILE] = Item.init(Type.CHAMOMILE, preload("res://entities/foraged/chamomile.tscn"))
	# items[Type.BLUE_CRYSTAL] = Item.init(Type.BLUE_CRYSTAL, preload("res://entities/foraged/blue_crystal.tscn"))
	# items[Type.PURPLE_CRYSTAL] = Item.init(Type.BLUE_CRYSTAL, preload("res://entities/foraged/purple_crystal.tscn"))

	# crops
	items[Type.GARLIC] = Item.init(Type.GARLIC, preload("res://entities/crops/garlic.tscn"))
	items[Type.TOMATO] = Item.init(Type.TOMATO, preload("res://entities/crops/tomato.tscn"))

func set_farm(_farm: Farm) -> void:
	if farm != null:
		print("farm already assigned")
		return
	farm = _farm

func set_scene(_scene: Node2D) -> void:
	scene = _scene

func get_item(type: Type) -> Node2D:
	if type == Type.NONE:
		return null
	return items[type].scene.instantiate()

func spawn(type: Type, global_pos: Vector2) -> Node:
	var item = items[type].scene.instantiate()
	scene.add_child(item)
	item.global_position = global_pos
	return item

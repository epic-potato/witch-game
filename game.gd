class_name Game

extends Node

enum Type {
	RED_CAP,
	GARLIC,
	END,
}

func type_to_str(type: Type) -> String:
	match type:
		Type.RED_CAP:
			return "red_cap"
		Type.GARLIC:
			return "garlic"
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
	items.resize(Type.END)
	items[Type.RED_CAP] = Item.init(Type.RED_CAP, preload("res://entities/red_cap.tscn"))
	items[Type.GARLIC] = Item.init(Type.GARLIC, preload("res://entities/garlic.tscn"))
	call_deferred("_parent_farm", self)

func set_farm(_farm: Farm) -> void:
	if farm != null:
		print("farm already assigned")
		return
	farm = _farm

func set_scene(_scene: Node2D) -> void:
	scene = _scene

func spawn(type: Type, global_pos: Vector2) -> Node:
	var item = items[type].scene.instantiate()
	scene.add_child(item)
	item.global_position = global_pos
	return item

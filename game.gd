class_name Game

extends Node

enum Type {
	RED_CAP,
}

@export var root: Node
@export var red_cap: PackedScene

@onready var farm = preload("res://farm.gd")

class InnerItem:
	var type: Type
	var scene: PackedScene

	static func init(_type: Type, _scene: PackedScene) -> InnerItem:
		var item = InnerItem.new()
		item.type = _type
		item.scene = _scene
		return item

var items: Array[InnerItem] = []

func _ready() -> void:
	items[Type.RED_CAP] = InnerItem.init(Type.RED_CAP, red_cap)

func spawn(type: Type, global_pos: Vector2) -> Node:
	var item = items[type].scene.instantiate()
	root.add_child(item)
	item.global_position = global_pos
	return item

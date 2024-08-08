class_name Items

enum Type {
	RED_CAP,
}

class InnerItem:
	var type: Type
	var scene: PackedScene

	static func init(_type: Type, _scene: PackedScene) -> InnerItem:
		var item = InnerItem.new()
		item.type = _type
		item.scene = _scene
		return item

static var items: Dictionary = {
	Type.RED_CAP: InnerItem.init(Type.RED_CAP, preload("res://entities/red_cap.tscn")),
}

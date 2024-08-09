class_name Interact

extends Area2D

@export var interactable: bool = true

enum Type { FORAGE, PICKUP, MESSAGE, NONE }

class Result:
	var type: Type
	var forage: Bag.Item
	var pickup: Bag.Item
	var message: String

	static func none() -> Result:
		return Result.new(Type.NONE, null)

	func _init(_type: Type, payload: Variant):
		type = _type
		match _type:
			Type.FORAGE:
				assert(payload is Bag.Item)
				forage = payload
			Type.PICKUP:
				assert(payload is Bag.Item)
				pickup = payload
			Type.MESSAGE:
				assert(payload is String)
				message = payload


func interact() -> Result:
	return Result.none()

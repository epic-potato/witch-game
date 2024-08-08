class_name Bag

extends Node

class Item:
	var name: String
	var count: int

	func _init(p_name: String, p_count: int) -> void:
		name = p_name
		count = p_count

@export var capacity: int = 10
@export var stack_size: int = 5

var items: Array[Item] = []

func _ready():
	items.resize(capacity)
	items.fill(null)

func add(new_item: Item) -> bool:

	print("Attempting to add %d %s" % [new_item.count, new_item.name])
	var empty_idx = -1
	for idx in items.size():
		var item = items[idx]
		if item == null:
			# capture first empty so we can use it if we need a new slot
			if empty_idx < 0:
				empty_idx = idx
			continue

		var available_space = stack_size - item.count
		if item.name == new_item.name:
			if available_space > new_item.count:
				item.count += new_item.count
				new_item.count = 0
				break

			item.count += available_space
			new_item.count -= available_space

	if new_item.count > 0:
		if empty_idx >= 0:
			# if we aren't at capacity, then empty_idx MUST be a valid idx
			print("Taking a slot")
			items[empty_idx] = new_item
		else:
			return false

	return true


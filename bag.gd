class_name Bag

extends Node 

static func make(cap: int, stack: int) -> Bag:
	var bag := Bag.new()
	bag.capacity = cap
	bag.stack_size = stack
	bag._ready()

	return bag

class Item:
	var type: Game.Type
	var count: int

	func _init(p_type: Game.Type, p_count: int) -> void:
		type = p_type
		count = p_count

@export var capacity: int = 10
@export var stack_size: int = 5

var active_idx: int = 0

var items: Array[Item] = []

func _ready():
	items.resize(capacity)
	items.fill(null)

func get_next_item() -> Game.Type:
	for idx in items.size():
		if idx > active_idx:
			if items[idx] != null:
				active_idx = idx
func add(new_item: Item) -> bool:
	var empty_idx = -1
	for idx in items.size():
		var item = items[idx]
		if item == null:
			# capture first empty so we can use it if we need a new slot
			if empty_idx < 0:
				empty_idx = idx
			continue

		var available_space = stack_size - item.count
		if item.type == new_item.type:
			if available_space > new_item.count:
				item.count += new_item.count
				new_item.count = 0
				break

			item.count += available_space
			new_item.count -= available_space

	if new_item.count > 0:
		if empty_idx >= 0:
			# if we aren't at capacity, then empty_idx MUST be a valid idx
			items[empty_idx] = new_item
		else:
			return false

	return true


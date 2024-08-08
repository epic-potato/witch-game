extends Interactable

@export var item: Item
@export var count: int

func _ready():
	var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var rng := RandomNumberGenerator.new()
	sprite.frame = rng.randi_range(0, total_frames)

func interact() -> Item:
	item.count = count
	self.queue_free()
	return item

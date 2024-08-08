extends Interactable

@export var item_name: String
@export var count: int

func _ready():
	var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var rng := RandomNumberGenerator.new()
	sprite.frame = rng.randi_range(0, total_frames)

func interact(player: Player) -> void:
	player.bag.add(Bag.Item.new(item_name, count))
	self.queue_free()

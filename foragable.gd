class_name Forageable

extends Interact

@export var type: Game.Type
@export var count: int
@export var random_frame: bool = true

func _ready():
	if !random_frame:
		return

	var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var rng := RandomNumberGenerator.new()
	sprite.frame = rng.randi_range(0, total_frames)

func interact() -> Interact.Result:
	print("I'm foraged! My type is:")
	print(game.type_to_str(type))
	var result := Interact.Result.new(Interact.Type.FORAGE, Bag.Item.new(type, count))
	self.queue_free()
	return result

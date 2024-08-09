class_name Plant

extends Forageable

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() ->void:
	pass

func set_frame(frame: int) -> void:
	sprite.visible = frame >= 0
	if sprite.visible:
		sprite.frame = frame
	else:
		sprite.frame = 0

func interact() -> Interact.Result:
	if sprite.frame != 2:
		return Interact.Result.new(Interact.Type.MESSAGE, "It isn't ripe yet...")
	print("I'm foraged! My type is:")
	print(game.type_to_str(type))
	var result := Interact.Result.new(Interact.Type.FORAGE, Bag.Item.new(type, count))
	self.queue_free()
	return result

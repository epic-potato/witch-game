class_name Plant

extends Forageable

@export var time_to_ripe = 300
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() ->void:
	pass

# TODO (etate): change this to set_state and handle frames from there
func set_frame(frame: int) -> void:
	sprite.visible = frame >= 0
	if sprite.visible:
		sprite.frame = frame
	else:
		sprite.frame = 0

func interact() -> Interact.Result:
	if !interactable:
		return Interact.Result.none()

	if sprite.frame != 2:
		return Interact.Result.new(Interact.Type.MESSAGE, "It isn't ripe yet...")
	var result := Interact.Result.new(Interact.Type.FORAGE, Bag.Item.new(type, count))
	self.queue_free()
	return result

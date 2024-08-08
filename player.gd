class_name Player

extends CharacterBody2D

enum Face { LEFT, RIGHT }
enum State { IDLE, WALK, FORAGE, USE }

@onready var col: CollisionShape2D = $collider
@onready var sprite: Sprite2D = $sprite
@onready var zone: Area2D = $interact_zone
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hoe: Hoe = $hoe

@export var speed: int = 50
@export var bag: Bag

var state: State = State.IDLE
var facing: Face = Face.RIGHT

var timer: float = 0
var step_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if bag == null:
		bag = $bag


func interact():
	var items = zone.get_overlapping_areas()
	for item in items:
		if item.has_method("interact"):
			state = State.FORAGE
			item.interact(self)
			return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if state ==State.FORAGE:
		timer += dt
		if timer <= 1:
			return

	timer = 0
	state = State.IDLE
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y = -speed * Input.get_action_strength("up");

	if Input.is_action_pressed("down"):
		velocity.y = speed * Input.get_action_strength("down");

	if Input.is_action_pressed("left"):
		velocity.x = -speed * Input.get_action_strength("left");
		facing = Face.LEFT

	if Input.is_action_pressed("right"):
		velocity.x = speed * Input.get_action_strength("right");
		facing = Face.RIGHT


	if velocity.length() > 0:
		state = State.WALK

	if Input.is_action_pressed("action"):
		interact()

	if Input.is_action_pressed("use"):
		hoe.swing()

	# normalize diagonal speeds
	var mag = velocity.length()
	if mag > speed:
		velocity = (velocity / mag) * speed

	match facing:
		Face.RIGHT:
			sprite.flip_h = true
			sprite.offset.x = -4;
			hoe.scale.x = -1
			hoe.position.x = 6
		Face.LEFT:
			sprite.flip_h = false
			sprite.offset.x = 0;
			hoe.scale.x = 1
			hoe.position.x = -6

	move_and_slide()


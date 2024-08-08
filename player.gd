class_name Player

extends CharacterBody2D

enum Face { LEFT, RIGHT }
enum State { IDLE, WALK, FORAGE, USE }

@onready var col: CollisionShape2D = $collider
@onready var sprite: AnimatedSprite2D = $sprite
@onready var zone: Area2D = $interact_zone
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hoe: Hoe = $hoe
@onready var guide: Node2D = $guide
@onready var plot_scn := preload("res://entities/plot.tscn")

@export var speed: int = 50

var state: State = State.IDLE
var facing: Face = Face.RIGHT

var timer: float = 0
var step_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func interact():
	var items = zone.get_overlapping_areas()
	for item in items:
		if item.has_method("interact"):
			var inter = item as Interact
			var result := inter.interact()
			match result.type:
				Interact.Type.FORAGE:
					state = State.FORAGE
					print("Collecting: %s" % game.type_to_str(result.forage.type))
					game.bag.add(result.forage)
				_:
					print("WTF")
			return

func handle_anim():
	match state:
		State.IDLE:
			sprite.play("idle_look_up")
		State.WALK:
			sprite.play("idle_bounce")

func get_plot_pos() -> Vector2:
	var mouse_pos := get_global_mouse_position()
	var diff := (global_position - mouse_pos).normalized()
	var snap_pos := Vector2(1, 0)

	var snapped_angle: float = round(diff.angle()/(PI/4))*(PI/4)
	if snapped_angle == 0 or snapped_angle == 2*PI:
		snap_pos = Vector2(-1, 0)
	if snapped_angle == PI/4:
		snap_pos = Vector2(-1, -1)
	if snapped_angle == PI/2:
		snap_pos = Vector2(0, -1)
	if snapped_angle == 3*PI/4:
		snap_pos = Vector2(1, -1)
	if abs(snapped_angle) == PI:
		snap_pos = Vector2(1, 0)
	if snapped_angle == -3*PI/4:
		snap_pos = Vector2(1, 1)
	if snapped_angle == -PI/2:
		snap_pos = Vector2(0, 1)
	if snapped_angle == -PI/4:
		snap_pos = Vector2(-1, 1)

	return (Vector2(round(position.x / 16), round(position.y / 16)) + snap_pos) * 16


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if state == State.FORAGE:
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

	if Input.is_action_just_pressed("use"):
		game.farm.till_plot(get_plot_pos())
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

	handle_anim()
	move_and_slide()
	guide.global_position = get_plot_pos()


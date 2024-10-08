class_name Player

extends CharacterBody2D

enum Face { LEFT, RIGHT }
enum State { IDLE, WALK, FORAGE, USE }

@onready var speech: Label = $Label
@onready var col: CollisionShape2D = $collider
@onready var sprite: AnimatedSprite2D = $sprite
@onready var zone: Area2D = $interact_zone
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var guide: Node2D = $guide
@onready var plot_scn := preload("res://entities/plot.tscn")

@export var speed: int = 90

var state: State = State.IDLE
var facing: Face = Face.RIGHT

var timer: float = 0
var step_time: float = 0
var last_plot_dir: Vector2i = Vector2i.ZERO
var mouse_mode = false
var speech_timer: float = 0
var tool_is_active: bool = false

var active_item: Game.Type = Game.Type.NONE
var tool: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func say(msg: String):
	speech.text = msg
	speech_timer = 3


func active_item_type() -> Game.Type:
	var item = game.bag.get_active_item()
	if active_item != item:
		active_item = item

		if tool != null:
			tool.queue_free()

		if item == Game.Type.NONE:
			return item

		tool = game.get_item(item)
		tool.position.x -= 8
		tool.position.y -= 6
		tool.z_index = 1
		add_child(tool)
		if tool is Interact:
			tool.interactable = false
		if tool is Plant:
			var plant = tool as Plant
			plant.set_frame(3)
	return item


func interact():
	var items = zone.get_overlapping_areas()
	for item in items:
		if item.has_method("interact"):
			var inter = item as Interact
			var result := inter.interact()
			match result.type:
				Interact.Type.FORAGE:
					state = State.FORAGE
					game.bag.add(result.forage)
				Interact.Type.MESSAGE:
					say(result.message)
				Interact.Type.NONE:
					continue
			return


func use() -> void:
	var curr_item = active_item_type()
	match curr_item:
		Game.Type.NONE:
			say("I don't have anything")
			return
		Game.Type.HOE:
			var hoe = tool as Hoe
			var plot = game.farm.till_plot(get_plot_pos())
			if plot == null:
				say("There's already a plot here!")
			hoe.swing()
		Game.Type.WATERING_CAN:
			var can = tool as WateringCan
			var plot = game.farm.get_plot(get_plot_pos())
			if plot == null or plot.state == Plot.State.EMPTY:
				say("There's nothing to water here...")
				return
			can.use()
			plot.water()
			return
		_:
			var item: Node2D = game.get_item(curr_item)
			if item is Plant:
				var plant: Plant = item as Plant
				var plot = game.farm.get_plot(get_plot_pos())
				if plot == null:
					say("The earth here isn't ready for planting...")
					return
				if plot.plant_seed(plant):
					game.bag.subtract_active(1)
				return
			if item is Forageable:
				var plot = game.farm.get_plot(get_plot_pos())
				if plot != null:
					say("I can't grow these, only the woods can!")
					return
				say("I'm not sure what to do with this...")
				return


func handle_visuals():
	active_item_type()
	if tool != null:
		tool.visible = state != State.FORAGE and tool_is_active

	guide.visible = tool_is_active
	match state:
		State.IDLE:
			sprite.play("idle_look_up")
		State.WALK:
			sprite.play("idle_bounce")

func get_gamepad_pos():
	var dir := get_gamepad_axes().normalized()
	if absf(dir.x) > absf(dir.y) * 2:
		dir.y = 0
	if absf(dir.y) > absf(dir.x) * 2:
		dir.x = 0


func get_plot_pos() -> Vector2:
	var dir = get_gamepad_axes().normalized()
	if dir == Vector2.ZERO:
		var mouse_pos := get_global_mouse_position()
		dir = (mouse_pos - global_position).normalized()

	if absf(dir.x) > absf(dir.y) * 2:
		dir.y = 0
	if absf(dir.y) > absf(dir.x) * 2:
		dir.x = 0

	dir = dir.sign()

	return (Vector2(round(position.x / 16), round(position.y / 16)) + dir) * 16


func get_gamepad_axes() -> Vector2:
	return Vector2(Input.get_axis("point_left", "point_right"), Input.get_axis("point_up", "point_down"))

func is_tool_active() -> bool:
	return Input.is_action_pressed("ready_tool") or get_gamepad_axes() != Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if state == State.FORAGE:
		timer += dt
		if timer <= 1:
			return

	timer = 0
	state = State.IDLE
	velocity = Vector2(0, 0)

	tool_is_active = is_tool_active()
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

	if Input.is_action_just_pressed("action"):
		interact()

	if Input.is_action_just_pressed("use"):
		if tool_is_active:
			use()

	if Input.is_action_just_pressed("next_item"):
		game.bag.get_next_item()

	if Input.is_action_just_pressed("prev_item"):
		game.bag.get_prev_item()

	# normalize diagonal speeds
	var mag = velocity.length()
	if mag > speed:
		velocity = (velocity / mag) * speed

	match facing:
		Face.RIGHT:
			sprite.flip_h = true
			sprite.offset.x = -4;
			if tool != null:
				tool.scale.x = -1
				tool.position.x = 6
		Face.LEFT:
			sprite.flip_h = false
			sprite.offset.x = 0;
			if tool != null:
				tool.scale.x = 1
				tool.position.x = -10

	if speech_timer > 0:
		speech_timer -= dt
	else:
		speech.text = ""

	handle_visuals()
	move_and_slide()
	guide.global_position = get_plot_pos()


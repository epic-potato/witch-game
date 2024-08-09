class_name Plot

extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var plant: Plant

enum State { EMPTY, SEED, SEED2, SPROUT, UNRIPE, RIPE }

var settled: bool = false
var watered: bool = true
var time_until_dry: float = 0
var elapsed: float = 0
var state: State = State.EMPTY


func _ready() -> void:
	pass


func get_frame():
	match state:
		State.EMPTY:
			return 1
		State.SEED:
			return 3
		_:
			return 5

func get_plant_frame():
	match state:
		State.SPROUT:
			return 0
		State.UNRIPE:
			return 1
		State.RIPE:
			return 2
		_:
			return -1

func plant_seed(plnt: Plant):
	if state == State.EMPTY:
		elapsed = randf_range(0, plnt.time_to_ripe / 10)
		plant = plnt
		add_child(plant)
		plant.set_frame(-1)
		plant.count = 2 + int(randi() % 10 == 0) # at least 2, 10% chance of 3
		state = State.SEED

func water():
	time_until_dry = 120 + randf_range(0, 30)

func handle_state():
	var frame = get_frame()
	if time_until_dry > 0:
		frame -= 1

	sprite.frame = frame
	if plant != null:
		plant.set_frame(get_plant_frame())
	else:
		state = State.EMPTY

func _process(dt: float) -> void:
	time_until_dry = max(0, time_until_dry - dt)

	if time_until_dry > 0:
		sprite.frame = 0
	else:
		sprite.frame = 1

	if plant != null:
		if state != State.EMPTY and time_until_dry > 0:
			elapsed += dt

		var percent_time_waited = elapsed/plant.time_to_ripe
		if percent_time_waited < .2:
			state = State.SEED
		elif percent_time_waited < .4:
			state = State.SEED2
		elif percent_time_waited < .6:
			state = State.SPROUT
		elif percent_time_waited < .8:
			state = State.UNRIPE
		else:
			state = State.RIPE
	else:
		state = State.EMPTY


	handle_state()

# this is dumb, but we have to wait for the first physics tick
func _physics_process(_dt) -> void:
	if !settled:
		var overlaps = get_overlapping_areas()
		for overlap in overlaps:
			if overlap is Plot:
				get_parent().remove_child(self)
	settled = true

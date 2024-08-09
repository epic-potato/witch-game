class_name Farm

extends Node2D

var plots: Dictionary = {}
@onready var plot_scn := preload("res://entities/plot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	y_sort_enabled = true
	global_position.y = 10_000
	game.set_farm(self)


func till_plot(pos: Vector2i) -> Plot:
	if plots.has(pos):
		print("Plot already tilled")
		return null

	print("Placing plot")
	var plot: Plot = plot_scn.instantiate()
	add_child(plot)
	plot.global_position = pos
	plots[pos] = plot
	return plot

func get_plot(pos: Vector2i) -> Plot:
	if plots.has(pos):
		return plots[pos]
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt: float) -> void:
	pass

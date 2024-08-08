class_name Farm

extends Node

var plots: Dictionary = {}
@onready var plot_scn := preload("res://entities/plot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func till_plot(pos: Vector2i) -> bool:
	if plots.has(pos):
		print("Plot already tilled")
		return false

	print("Placing plot")
	var plot: Plot = plot_scn.instantiate()
	add_child(plot)
	plot.global_position = pos
	plots[pos] = plot
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt: float) -> void:
	pass

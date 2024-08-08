class_name Plot

extends Area2D


var settled: bool = false

func _ready() -> void:
	var overlaps = get_overlapping_areas()
	for overlap in overlaps:
		print("FOUND SOME OVERLAPS!")
		if overlap is Plot:
			print("REMOVING PLOT")
			get_parent().remove_child(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_dt) -> void:
	if !settled:
		var overlaps = get_overlapping_areas()
		for overlap in overlaps:
			print("FOUND SOME OVERLAPS!")
			if overlap is Plot:
				print("REMOVING PLOT")
				get_parent().remove_child(self)
	settled = true

extends Sprite2D


@onready var shadow_texture: Texture2D = preload("res://sprites/shadow.png")

func init():
	var shadow_group: CanvasGroup
	var parent := get_parent()
	var group := parent.get_node_or_null("shadow_group")

	if parent.name == "shadow_group":
		return

	while group == null:
		parent = parent.get_parent()
		if parent == null:
			print("no shadow group found")
			return
		group = parent.get_node_or_null("shadow_group")


	if group is CanvasGroup:
		shadow_group = group
	else:
		print("shadow_group must be a CanvasGroup")
		return

	parent = get_parent()
	var shadow := Sprite2D.new()
	shadow_group.add_child(shadow)
	shadow.texture = shadow_texture
	shadow.position = Vector2.ZERO
	shadow.scale = Vector2.ZERO
	shadow.rotation = 0

	# have shadow track original parent
	var remote_xform = RemoteTransform2D.new() 

	self.add_child(remote_xform)
	remote_xform.remote_path = remote_xform.get_path_to(shadow)

	self.visible = false

# attach to the nearest shadow_group and replace itself with a RemoteTransform2D
func _ready():
	call_deferred("init")

extends CharacterBody2D

@export var speed: int = 50

@onready var col: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt):
	velocity = Vector2(0, 0)
	if Input.is_key_pressed(KEY_W):
		velocity.y = -speed;

	if Input.is_key_pressed(KEY_S):
		velocity.y = speed;

	if Input.is_key_pressed(KEY_A):
		velocity.x = -speed;

	if Input.is_key_pressed(KEY_D):
		velocity.x = speed;

	move_and_slide()


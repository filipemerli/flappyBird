extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0
var isDead = false
var didStartGame = false
signal didTouch
const birdYPos = 255
var isUp: bool = true

@onready var anim = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	connect("didTouch", handleTouch)

func _physics_process(delta):
	if not is_on_floor() and didStartGame:
		velocity.y += gravity * delta
	if get_slide_collision_count() != 0:
		die()
	move_and_slide()
	rotate_bird()

func die():
	if not isDead:
		set_collision_mask_value(2, false)
		anim.stop()
		isDead = true
		get_parent().emit_signal("birdDied")

func handleTouch():
	if didStartGame == false:
		didStartGame = true
	if not isDead:
		rotation = 0
		velocity.y = JUMP_VELOCITY

func rotate_bird():
	# Rotate downwards when falling
	if velocity.y > 0 and rad_to_deg(rotation) < 90:
		rotation += 2 * deg_to_rad(1.4)
	# Rotate upwards when rising
	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
		rotation -= 2 * deg_to_rad(1.2)

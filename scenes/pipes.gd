extends Node2D

var velocity = Vector2.ZERO
var speed = 90
const direction = Vector2.LEFT
var didEmitSignal = false
signal scoreUp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Global.isPlaying:
		velocity = direction * speed
		position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("bird"):
		if !didEmitSignal:
			didEmitSignal = true
			emit_signal("scoreUp")
	

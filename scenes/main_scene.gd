extends Node2D

@onready var bird = $Bird
@onready var movingFloor = $floor
@onready var label = $MenuLayer/Label
@onready var btn = $MenuLayer/Button
@onready var timer = $Timer
@onready var readyTxt = $MenuLayer/readyTxt
@onready var gameOverTxt = $MenuLayer/gameOver
signal birdDied

var floorSprite
var score = 0
var shouldMoveObjs: bool = false
var birdIsDead: bool = false
var didStartGame: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("birdDied", birdDidDie)
	floorSprite = movingFloor.get_node("%floorSprite")
	floorSprite.material.set_shader_parameter("speed", 0.28)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		bird.emit_signal("didTouch")
		if !didStartGame:
			didStartGame = true
			Global.isPlaying = true
			readyTxt.visible = false
			pipesGenerator()

func pipesGenerator():
	if birdIsDead == false and didStartGame:
		var pipe = preload("res://scenes/pipes.tscn").instantiate()
		pipe.position = Vector2(320, randf_range(95, 305))
		pipe.connect("scoreUp", scoreUp)
		call_deferred("add_child", pipe)
		timer.start(2.0)

func _on_remove_pipes_area_entered(area):
	area.queue_free()

func scoreUp():
	score += 1
	label.text = str(score)

func birdDidDie():
	Global.isPlaying = false
	floorSprite.material.set_shader_parameter("speed", 0.0)
	#stop pipes
	showModal()

func showModal():
	btn.visible = true
	gameOverTxt.visible = true

func _on_button_pressed():
	get_tree().reload_current_scene()

func _on_timer_timeout():
	if birdIsDead == false and didStartGame:
		pipesGenerator()

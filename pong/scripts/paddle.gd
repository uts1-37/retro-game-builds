extends Area2D

var active = true

@export var is_ai = false
@export var is_player_one = false



@onready var cshape: CollisionShape2D = $CollisionShape2D
var up_input = "paddle_up"
var down_input = "paddle_down"

var MAX_VELOCITY = 10.0 
var velocity = 0.0
var acceleration = 60.0

var ai_target_ypos = 360.0

enum Difficulty { EASY, NORMAL, HARD }
@export var difficulty: Difficulty = Difficulty.NORMAL

var accuracy_dist = 15.0
var aim_error = 0.0     


func _ready() -> void:
	if is_player_one == false:
		up_input += "_2"
		down_input += "_2"

func _physics_process(delta: float) -> void:
	if !active: return
	
	var move_dir = 0.0
	
	if !is_ai:
		move_dir = Input.get_axis(up_input, down_input)
	else:
		move_dir = get_ai_movement_dir()
	
	velocity += move_dir * acceleration * delta
	if move_dir == 0.0:
		velocity = move_toward(velocity , 0.0 , 2.0)
	velocity = clampf(velocity , -MAX_VELOCITY , MAX_VELOCITY)
	
	global_position.y += velocity
	
	global_position.y = clampf(global_position.y , 50 , get_window().size.y - 50)



func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddle(global_position.y, cshape.shape.get_rect().size.y)

func get_ai_movement_dir():
	var dist_to_target = abs(ai_target_ypos - global_position.y)

	
	if (dist_to_target > accuracy_dist):
		if ai_target_ypos > global_position.y:
			return 1
		else:
			return -1
		
	else:
		return 0
		

	
func apply_difficulty():
	match difficulty:
		Difficulty.EASY:
			MAX_VELOCITY = 3.5
			acceleration = 20.0
		Difficulty.NORMAL:
			MAX_VELOCITY = 5.5
			acceleration = 35.0
		Difficulty.HARD:
			MAX_VELOCITY = 10.0
			acceleration = 60.0
			

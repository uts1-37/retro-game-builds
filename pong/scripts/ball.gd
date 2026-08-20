extends CharacterBody2D
class_name Ball

@onready var beep_1: AudioStreamPlayer2D = $Beep1
@onready var beep_2: AudioStreamPlayer2D = $Beep2


signal bounced

@export var speed_increase_per_bounce = 20

var active = false 

var debug_mode = false


const START_SPEED = 700
const FIRST_SERVE_SPEED = 350
var speed = START_SPEED

var move_dir = Vector2(-1 , 0)

var is_first_hit = true

@onready var cshape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if !active: return
	
	if debug_mode:
		var vertical_dir = Input.get_axis("ball_up", "ball_down")
		var horizontal_dir = Input.get_axis("ball_left", "ball_right")
		move_dir = Vector2(horizontal_dir , vertical_dir)
		pass
		if move_dir.x != 0.0 || move_dir.y != 0.0:
			velocity = move_dir * speed
		else:
			velocity = Vector2.ZERO
			
	else:
		velocity =  move_dir * speed
		
	var collided = move_and_slide()
	
	if collided:
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())
		play_beep()

	
		
func bounce_from_paddle(paddle_y_pos, paddle_height):
	var new_move_dir_y = (global_position.y - paddle_y_pos) / (paddle_height/2.0)
	move_dir.y = new_move_dir_y
	move_dir.x *= -1
	
	if is_first_hit:
		is_first_hit = false
		speed = START_SPEED
	
	speed += speed_increase_per_bounce
	
	play_beep()
	
	bounced.emit()
	
	
	
func reset(reset_pos):
	global_position = reset_pos
	speed = FIRST_SERVE_SPEED
	
	move_dir.y = randf() * [-1, 1].pick_random()

	active = false 
	
func get_size():
	return cshape.shape.get_rect().size
	
func play_beep():
	var beep = [beep_1, beep_2].pick_random()
	beep.pitch_scale = [0.8, 1.0, 1.2].pick_random()

	beep.play()
	

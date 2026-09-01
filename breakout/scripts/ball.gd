extends CharacterBody2D
class_name Ball

const START_SPEED = 500
var speed = START_SPEED

var move_dir = Vector2(0, 1)
var new_move_dir_x


func _physics_process(delta: float) -> void:
	
	move_dir = move_dir.normalized()
	velocity = move_dir * speed
	
	var collided = move_and_slide()
	
	if collided:
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())
		

func bounce_from_paddle(paddle_x_pos, paddle_length):
	new_move_dir_x = (global_position.x - paddle_x_pos) / (paddle_length / 2.0)
	global_position.y -= 16
	move_dir.x = new_move_dir_x
	move_dir.y = -1
	move_dir = move_dir.normalized()
	
	
func bounce_from_brick(normal: Vector2) -> void:
	if normal.x != 0.0:   
		move_dir.x = absf(move_dir.x) * normal.x
	if normal.y != 0.0:
		move_dir.y = absf(move_dir.y) * normal.y
	

	
	
	

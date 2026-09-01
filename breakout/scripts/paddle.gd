extends Area2D

@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var half_size = cshape.shape.get_rect().size.x / 2.0


var left_input = "paddle_left"
var right_input = "paddle_right"

var MAX_VELOCITY = 13.0
var velocity = 0
var acceleration = 100.0

func _physics_process(delta: float) -> void:
	var move_dir = 0.0
	
	move_dir = Input.get_axis(left_input , right_input)
	
	velocity += move_dir * acceleration * delta
	
	if move_dir == 0.0:
		velocity = move_toward(velocity , 0.0 , 100.0)
		
	velocity = clampf(velocity , -MAX_VELOCITY , MAX_VELOCITY)
	
	global_position.x += velocity
	
	global_position.x = clampf(global_position.x , half_size , get_window().size.x - half_size)


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddle(global_position.x, cshape.shape.get_rect().size.x)
		

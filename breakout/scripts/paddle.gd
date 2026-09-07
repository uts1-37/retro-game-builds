extends Area2D

@onready var cshape: CollisionShape2D = $CollisionShape2D
#@onready var half_size = cshape.shape.get_rect().size.x / 2.0

const SHRUNK_SCALE = 0.5
var shrunk := false

var left_input = "paddle_left"
var right_input = "paddle_right"

var MAX_VELOCITY = 13.0
var velocity = 0
var acceleration = 100.0

var can_move = true
func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	var move_dir = 0.0
	
	move_dir = Input.get_axis(left_input , right_input)
	
	velocity += move_dir * acceleration * delta
	
	if move_dir == 0.0:
		velocity = move_toward(velocity , 0.0 , 100.0)
		
	velocity = clampf(velocity , -MAX_VELOCITY , MAX_VELOCITY)
	
	global_position.x += velocity
	
	global_position.x = clampf(global_position.x , half_size() , get_window().size.x - half_size())


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddle(global_position.x, cshape.shape.get_rect().size.x)
func half_size() -> float:
	return cshape.shape.size.x / 2.0 * cshape.scale.x

func shrink():
	if shrunk:
		return
	shrunk = true
	
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property($MeshInstance2D, "scale:x", SHRUNK_SCALE, 0.2)
	tween.tween_property($CollisionShape2D, "scale:x", SHRUNK_SCALE, 0.2)
	

func reset_size() -> void:
	shrunk = false
	$MeshInstance2D.scale.x = 1.0
	$CollisionShape2D.scale.x = 1.0

extends Node2D


var game_area_size = Vector2(1280, 720)

@onready var paddle1: Area2D = $Paddles/Paddle_1
@onready var paddle2: Area2D = $Paddles/Paddle_2
@onready var ball: CharacterBody2D = $THEball/Ball

@onready var detector_left: Area2D = $Environment/DetectorLeft
@onready var detector_right: Area2D = $Environment/DetectorRight

@onready var start_delay: Timer = $StartDelay


var score = Vector2i.ZERO
@export var final_score = 1
@onready var hud: Control = $CanvasLayer/HUD

@onready var l2d: Line2D = $THEball/BallMovementLine2D


@onready var ball_out_sound: AudioStreamPlayer2D = $THEball/BallOutSound



func _ready() -> void:
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	ball.bounced.connect(_on_ball_bounced)
	
	randomize()
	


func _process(delta: float) -> void:
	#for debugging
	#if Input.is_action_just_pressed("quit"):
		#get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	#if Input.is_action_just_pressed("ball_control"):
		#ball.debug_mode = !ball.debug_mode
		#paddle1.active = !ball.debug_mode
		#if !ball.debug_mode:
			#ball.move_dir = Vector2(-1, 0)
			
	#if Input.is_action_just_pressed("show_line"):
		#l2d.visible = !l2d.visible
		
	
		

		
		


func _draw() -> void:
	var line_start = Vector2(game_area_size.x/2.0, 0)
	var line_end = Vector2(game_area_size.x/2.0 , game_area_size.y)
	draw_dashed_line(line_start , line_end , Color.WHITE, 8.0 , 12.0, false)

func reset_game():
	score = Vector2i.ZERO
	hud.reset_score()
	reset_round()

func reset_round():
	ball.is_first_hit = true
	var reset_pos = game_area_size / 2.0
	ball.reset(reset_pos)
	
	if paddle1.is_ai:
		paddle1.MAX_VELOCITY = 10.0
		paddle1.acceleration = 60.0
		
	start_delay.start()
	await start_delay.timeout
	ball.active = true 
	simulate_ball_movement()
	
	if paddle1.is_ai:
		await get_tree().create_timer(1.5).timeout
		paddle1.apply_difficulty()
	

func _on_detector_ball_out(is_left):
	if is_left:
		score.y += 1
	else:
		score.x += 1 
		
	hud.set_new_score(score)
	
	ball_out_sound.play()
	
	l2d.clear_points()
		
	if score.x >= final_score:
		hud.show_game_over(0)
		paddle2.active = false
		paddle1.active = false
	elif score.y >= final_score:
		hud.show_game_over(1)
		paddle2.active = false
		paddle1.active = false
	else:
		reset_round()
		
		
func update_l2d(points):
	l2d.clear_points()
	l2d.global_position = ball.global_position
	for point in points:
		var localized_point = l2d.to_local(point)
		l2d.add_point(localized_point)

func _on_ball_bounced():
	simulate_ball_movement()

		
func simulate_ball_movement(seconds: float = 3.0):
	var ball_pos = ball.global_position
	var move_dir_copy = ball.move_dir
	var bs = ball.get_size()
	
	var top_limit = bs.y / 2.0
	var bottom_limit = game_area_size.y - (bs.y / 2.0)
	var left_limit = paddle1.global_position.x + (bs.x / 2.0)
	var right_limit = paddle2.global_position.x - (bs.x / 2.0)
	
	var points = [ball_pos]
	var dt = get_physics_process_delta_time()
	
	for i in range(0 , 60 * seconds):
		ball_pos += move_dir_copy * ball.speed * dt
		
		if ball_pos.x <= left_limit || ball_pos.x >= right_limit:
			if (ball_pos.x <= left_limit) && (move_dir_copy.x > 0):
				pass
			elif (ball_pos.x >= right_limit) && (move_dir_copy.x < 0):
				pass
			else:
				break
				
		if ball_pos.y <= top_limit || ball_pos.y >= bottom_limit:
			move_dir_copy.y *= -1 
			points.append(ball_pos)

				
	points.append(ball_pos)
	
	if paddle1.is_ai:
		paddle1.ai_target_ypos = ball_pos.y + randf_range(-paddle1.aim_error , paddle1.aim_error)
	if paddle2.is_ai:
		paddle2.ai_target_ypos = ball_pos.y + randf_range(-paddle2.aim_error , paddle2.aim_error)
	update_l2d(points)
		
		
		
	

func _on_hud_one_player(difficulty) -> void:
	paddle1.is_ai = true
	paddle1.difficulty = difficulty
	paddle1.apply_difficulty()
	reset_game()
	
func _on_hud_two_player() -> void:
	paddle1.is_ai = false
	reset_game()



func _on_hud_restart() -> void:
	paddle2.active = true
	paddle1.active = true
	paddle1.ai_target_ypos = 360.0
	paddle2.ai_target_ypos = 360.0
	paddle1.global_position = Vector2(50 , 360)
	paddle2.global_position = Vector2(1230 , 360)
	reset_game()

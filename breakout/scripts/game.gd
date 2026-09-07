extends Node2D
@export var paddle: Area2D
@onready var ball: Ball = $Ball
@onready var hud: CanvasLayer = $HUD
@onready var brick_manager: Node2D = $BrickManager

var start = true
var wait = false

var score = 0
var high_score = 0

var save_file_path := "user://save_game.dat"

var life = 3
var level = 0

func _ready() -> void:
	load_high_score()
	paddle.can_move = true
	ball.visible = true

func _process(delta: float) -> void:
	if start:
		ball.global_position = paddle.global_position + Vector2(0, -13)
		
	if start and Input.is_action_just_pressed("launch") and !wait:
		start = false
		ball.start = false
		ball.move_dir = Vector2([-1, 1].pick_random(), -1).normalized()
	

	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
			


func _on_detector_out() -> void:
		start = true
		ball.start = true
		hud.lifespan_control(life)
		life -= 1
		ball.ball_out(paddle.global_position , life)
		if life < 0:
			game_over()


func _on_brick_manager_score_changed(total: int) -> void:
	hud.update_score(total)
	score = total
	if score > high_score:
		high_score = score
		save_high_score()
		
	
func game_over():
	hud.show_game_over_screen(score, high_score)
	paddle.can_move = false
	
func save_high_score():
	var save_data = FileAccess.open(save_file_path, FileAccess.WRITE)
	save_data.store_var(high_score)
	save_data.close()
	
func load_high_score():
	if FileAccess.file_exists(save_file_path):
		var save_data = FileAccess.open(save_file_path, FileAccess.READ)
		high_score = save_data.get_var()
		save_data.close()

#cleared signal 
func _on_brick_manager_cleared() -> void:
	level += 1
	start = true
	wait = true
	await hud.clear_effect()
	paddle.reset_size()
	await get_tree().create_timer(0.4).timeout
	
	brick_manager.spawn_bricks(level)
	wait = false


func _on_wall_up_ceiling_touched() -> void:
	paddle.shrink()

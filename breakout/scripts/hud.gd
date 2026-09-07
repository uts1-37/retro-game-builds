extends CanvasLayer
@onready var life_on: Array[Sprite2D] = [$Life/Life1On, $Life/Life2On, $Life/Life3On]
@onready var life_off: Array[Sprite2D] = [$Life/Life1Off, $Life/Life2Off, $Life/Life3Off]
@onready var score: Label = $ScoreLabel
@onready var game_over_screen: Control = $GameOverScreen
@onready var key_move: Sprite2D = $KeyMove
@onready var key_launch: Sprite2D = $KeyLaunch
@onready var clear_label: Label = $ClearLabel

var moved := false 
var launched := false



func _ready() -> void:
	for i in range(3):
		life_on[i].visible = true
	for i in range(3):
		life_off[i].visible = false
		
	score.text = "000000"
	
	key_move.modulate.a = 1.0
	key_launch.modulate.a = 0.0


	
	
func _physics_process(delta: float) -> void:
	if not moved and not launched and Input.is_action_just_pressed("launch"):
		moved = true
		launched = true
		fade(key_move, 0.0)
		
	elif not moved and (Input.is_action_just_pressed("paddle_left") or Input.is_action_just_pressed("paddle_right")):
		moved = true
		fade(key_launch, 1.0)
		fade(key_move, 0.0)
	
	elif moved and not launched and Input.is_action_just_pressed("launch"):
		launched = true
		fade(key_launch, 0.0)
	
func fade(node: Sprite2D, to: float) -> void:
	create_tween().tween_property(node, "modulate:a", to, 0.15)

func lifespan_control(life):
	life_on[life-1].visible = false
	life_off[life-1].visible = true
	
func update_score(total_score):
	score.text = "%06d" % total_score
	
func show_game_over_screen(total_score, high_score):
		game_over_screen.init_screen(total_score, high_score)
		game_over_screen.modulate.a = 0.0
	
		game_over_screen.visible = true
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(game_over_screen, "modulate:a", 1.0, 0.15)
		
		
func clear_effect():
	for i in range(3):
		clear_label.visible = true
		await get_tree().create_timer(0.1).timeout
		clear_label.visible = false
		await get_tree().create_timer(0.1).timeout

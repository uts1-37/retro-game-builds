extends Control
@onready var left_score: Label = $LeftScore
@onready var right_score: Label = $RightScore

signal one_player(difficulty: int)
signal two_player

signal restart


func _ready():
	$MainScreen/Difficulty/Easy.pressed.connect(_choosed_difficulty.bind(0))
	$MainScreen/Difficulty/Normal.pressed.connect(_choosed_difficulty.bind(1))
	$MainScreen/Difficulty/Hard.pressed.connect(_choosed_difficulty.bind(2))
	$EndScreen/Restart.pressed.connect(pressed_restart)
	$EndScreen/Home.pressed.connect(pressed_home)

func set_new_score(score):
	left_score.text = str(score.x)
	right_score.text = str(score.y)

func reset_score():
	left_score.text = "0"
	right_score.text = "0"
	

func _on_player_1_pressed() -> void:
	$MainScreen/Title.hide()
	$MainScreen/Player1.hide()
	$MainScreen/Player2.hide()
	choose_difficulty_screen_show()
	
	

func _on_player_2_pressed() -> void:
	$MainScreen/Screen.hide()
	$MainScreen/Title.hide()
	$MainScreen/Player1.hide()
	$MainScreen/Player2.hide()
	two_player.emit()
	
func choose_difficulty_screen_show():
	$MainScreen/Difficulty/Easy.show()
	$MainScreen/Difficulty/Normal.show()
	$MainScreen/Difficulty/Hard.show()

func _choosed_difficulty(difficulty):
	one_player.emit(difficulty)
	$MainScreen/Difficulty/Easy.hide()
	$MainScreen/Difficulty/Normal.hide()
	$MainScreen/Difficulty/Hard.hide()
	$MainScreen/Screen.hide()
	
func show_game_over(side):
	if side == 0:
		$EndScreen/LeftWin.global_position.x = 150.0
		$EndScreen/Restart.global_position.x = 138.0
		$EndScreen/Home.global_position.x = 138.0
		$EndScreen/LeftWin.show()
		$EndScreen/Restart.show()
		$EndScreen/Home.show()
	else:
		$EndScreen/LeftWin.global_position.x = 826.0
		$EndScreen/Restart.global_position.x = 814.0
		$EndScreen/Home.global_position.x = 814.0
		$EndScreen/LeftWin.show()
		$EndScreen/Restart.show()
		$EndScreen/Home.show()
		
	#for i in range(3):
		#$EndScreen/LeftWin.modulate = Color.YELLOW
		#await get_tree().create_timer(0.2).timeout
		#$EndScreen/LeftWin.modulate = Color.RED
		#await get_tree().create_timer(0.2).timeout
		#$EndScreen/LeftWin.modulate = Color.WHITE   
		#await get_tree().create_timer(0.2).timeout

	

func pressed_restart():
	$EndScreen/LeftWin.hide()
	$EndScreen/Restart.hide()
	$EndScreen/Home.hide()
	restart.emit()

	
func pressed_home():
	get_tree().reload_current_scene()

		

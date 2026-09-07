extends Control
@onready var score_num: Label = $Panel/ScoreLabel/ScoreNum
@onready var high_score_num: Label = $Panel/HighScoreLable/HighScoreNum


func init_screen(total_score, high_score):
	score_num.text = "%06d" % total_score
	high_score_num.text = "%06d" % high_score
	

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

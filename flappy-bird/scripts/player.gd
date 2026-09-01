extends RigidBody2D
class_name Player 

signal game_started
signal died
signal scored


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flap_sound: AudioStreamPlayer = $FlapSound
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var score_sound: AudioStreamPlayer = $ScoreSound

var started := false
var is_alive := true

var flap_force := -340.0
var flap_angular_force = -8.0

const MAX_FLAP_ANGLE = -30.0
const MAX_FALL_ANGLE = 30.0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("flap") && is_alive:
		if !started:
			start_game()	
		flap()
		
	if rotation_degrees <= MAX_FLAP_ANGLE:
		rotation_degrees = MAX_FLAP_ANGLE
		angular_velocity = 0.0
		
	if linear_velocity.y > 0:
		if rotation_degrees <= MAX_FALL_ANGLE:
			angular_velocity = 5.0
		else:
			angular_velocity = 0.0
			
	

func start_game() -> void:
	started = true
	gravity_scale = 1.0 
	game_started.emit()
	
func flap() -> void:
	linear_velocity.y = flap_force
	angular_velocity = flap_angular_force

	animation_player.play("flap")
	flap_sound.play()
	
func die():
	if is_alive:
		is_alive = false
		died.emit()
		hit_sound.play()

func score_point():
	if is_alive:
		scored.emit()
		score_sound.play()

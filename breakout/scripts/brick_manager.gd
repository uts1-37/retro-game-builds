extends Node2D

@export var brick_scene: PackedScene

const COLUMNS = 14
const ROWS = 8
const BRICK_WIDTH = 42
const BRICK_HEIGHT = 20
const GAP = 4
const TOP_OFFSET = 60

var total_points = 0

signal score_changed(total: int)

signal cleared
var remaining := 0

var palette_index := 0


const PALETTES = [
	# 0 original
	[Color.RED, Color.RED, Color.ORANGE, Color.ORANGE,
	 Color.GREEN, Color.GREEN, Color.YELLOW, Color.YELLOW],

	# 1. sunset
	[Color("8e2de2"), Color("c31432"), Color("e8490f"), Color("f16529"),
	 Color("f7971e"), Color("fca311"), Color("ffd200"), Color("fff45e")],

	# 2. ocean
	[Color("0b2b5e"), Color("11487f"), Color("1668a5"), Color("1b8ec4"),
	 Color("22b0d4"), Color("38cfd9"), Color("6fe3d2"), Color("a8f0e0")],

	# 3. neon
	[Color("ff006e"), Color("fb5607"), Color("ffbe0b"), Color("8ac926"),
	 Color("06d6a0"), Color("00b4d8"), Color("3a86ff"), Color("8338ec")],

	# 4. poison
	[Color("2d0a4e"), Color("4c1273"), Color("6a1b9a"), Color("8e24aa"),
	 Color("53b83a"), Color("7cc93f"), Color("a8d94a"), Color("d4e157")],

	# 5. amber
	[Color("4a2500"), Color("6b3800"), Color("8c4c00"), Color("ad6300"),
	 Color("cf7c00"), Color("e59700"), Color("f5b53c"), Color("ffd782")],

	# 6. ice
	[Color("eaf6ff"), Color("c9e6f8"), Color("a3d4f0"), Color("7ac0e8"),
	 Color("51a9dd"), Color("2f8fcc"), Color("1c73b0"), Color("11568c")],

	# 7. inferno
	[Color("fff3b0"), Color("ffd166"), Color("ff9f1c"), Color("f4661b"),
	 Color("d62828"), Color("9d0208"), Color("6a040f"), Color("370617")],
]

const ROW_POINTS = [7, 7, 5, 5, 3, 3, 1, 1] 

func _ready() -> void:
	spawn_bricks()
	
func spawn_bricks(level := 0):
	palette_index = level % PALETTES.size()
	var colors = PALETTES[palette_index]
	for row in ROWS:
		for col in COLUMNS:
			var brick = brick_scene.instantiate()
			brick.position = Vector2(col * (BRICK_WIDTH + GAP) + BRICK_WIDTH / 2.0 , TOP_OFFSET + row * (BRICK_HEIGHT + GAP) + BRICK_HEIGHT / 2.0 )
			brick.modulate = colors[row]
			brick.points = ROW_POINTS[row]
			brick.broken.connect(_on_brick_broken)
			
			add_child(brick)
			remaining += 1
			
			
func _on_brick_broken(points) -> void:
	total_points += points
	score_changed.emit(total_points)
	remaining -=1
	if remaining == 0:
		cleared.emit()
			

extends Node2D

@export var brick_scene: PackedScene

const COLUMNS = 14
const ROWS = 8
const BRICK_WIDTH = 42
const BRICK_HEIGHT = 20
const GAP = 4
const TOP_OFFSET = 60

var total_points = 0

const ROW_COLORS = [
	Color.RED,
	Color.RED,
	Color.ORANGE,
	Color.ORANGE,
	Color.GREEN,
	Color.GREEN,
	Color.YELLOW,
	Color.YELLOW
]

const ROW_POINTS = [7, 7, 5, 5, 3, 3, 1, 1] 

func _ready() -> void:
	spawn_bricks()
	
func spawn_bricks():
	for row in ROWS:
		for col in COLUMNS:
			var brick = brick_scene.instantiate()
			brick.position = Vector2(col * (BRICK_WIDTH + GAP) + BRICK_WIDTH / 2.0 , TOP_OFFSET + row * (BRICK_HEIGHT + GAP) + BRICK_HEIGHT / 2.0 )
			brick.modulate = ROW_COLORS[row]
			brick.points = ROW_POINTS[row]
			brick.broken.connect(_on_brick_broken)
			add_child(brick)
			
func _on_brick_broken(points) -> void:
	total_points += points
	#점수처리
	#print("깨짐! +", points)
	#print(total_points)
			

extends Area2D

signal broken(points)
@onready var cshape: CollisionShape2D = $CollisionShape2D
var points = 1

const BALL_RADIUS = 6.0



func _on_body_entered(body: Node2D) -> void:
	
	if body is Ball:
		var diff = body.global_position - global_position
		var half = cshape.shape.get_rect().size * 0.5 + Vector2(BALL_RADIUS, BALL_RADIUS)
		var pen = half - diff.abs()
		var dir: Vector2 = body.move_dir
		
		var t_x = INF
		var t_y = INF
		
		if dir.x != 0.0 and signf(dir.x) != signf(diff.x):
			t_x = pen.x / absf(dir.x)
		if dir.x != 0.0 and signf(dir.y) != signf(diff.y):
			t_y = pen.y / absf(dir.y)
		
		var normal = Vector2.ZERO
		
		if t_x < t_y:
			normal.x = signf(diff.x) if diff.x != 0.0 else -signf(dir.x)
		else:
			normal.y = signf(diff.y) if diff.y != 0.0 else -signf(dir.y)
		
		body.bounce_from_brick(normal)

		broken.emit(points)
		queue_free()

extends Area2D
signal out



func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		out.emit()
	
	

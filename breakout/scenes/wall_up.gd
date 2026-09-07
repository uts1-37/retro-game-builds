extends StaticBody2D
signal ceiling_touched


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Ball:
		ceiling_touched.emit()

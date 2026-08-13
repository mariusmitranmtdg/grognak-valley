extends Area2D

var direction: Vector2
var speed := 150

func setup(start_pos: Vector2, new_dir: Vector2):
	direction = new_dir
	position = start_pos

func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.hit(Enum.Tool.SWORD, direction * -1)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()

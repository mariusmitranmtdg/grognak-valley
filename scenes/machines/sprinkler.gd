extends Machine

signal water_plants(coord: Vector2i)

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	connect("water_plants", level.water_plants)
	return super.setup(pos, level, parent)

func _on_timer_timeout() -> void:
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.play("action")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	water_plants.emit(coord)

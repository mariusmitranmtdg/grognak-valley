extends Machine


func _on_timer_timeout() -> void:
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.play("action")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	

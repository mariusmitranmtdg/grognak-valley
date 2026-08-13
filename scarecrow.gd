extends Machine

signal shoot_projectile(start_pos: Vector2, dir: Vector2)

func _on_timer_timeout() -> void:
	var blobs = get_tree().get_nodes_in_group("Enemies")
	if blobs:
		shoot_projectile.emit(position, (get_nearest_enemy(blobs).position - position).normalized())

func get_nearest_enemy(enemies: Array) -> CharacterBody2D:
	var nearest_enemy = enemies[0]
	for enemy in enemies:
		if enemy.position.distance_to(position) <= nearest_enemy.position.distance_to(position):
			nearest_enemy = enemy
	return nearest_enemy

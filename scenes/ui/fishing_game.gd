extends Node2D

var y_range = 140
var velocity: float
var fish_velocity: float
var progress := 30.0
var sprite_size: Vector2
var bar_gravity := 90

func _process(delta: float) -> void:
	if visible:
		$FishSprite.position.y += fish_velocity * delta
		$FishSprite.position.y = clamp($FishSprite.position.y, -y_range / 2.0, y_range / 2.0)
		
		$BarSprite.position.y += bar_gravity * delta
		$BarSprite.position.y = clamp($BarSprite.position.y, -y_range / 2.0 + 15.0, y_range / 2.0 - 15.0)
		
		var bar_top = $BarSprite.position.y - sprite_size.y / 2
		var bar_bottom = $BarSprite.position.y + sprite_size.y / 2
		if $FishSprite.position.y <= bar_bottom and $FishSprite.position.y >= bar_top:
			progress += 10 * delta
		else:
			progress -= 10 * delta
		
		$Control/TextureProgressBar.value = progress


func reveal():
	show()
	sprite_size = $BarSprite.get_rect().size

func _ready() -> void:
	hide()
	$FishSprite.position.y = randi_range(-y_range / 2.0, y_range / 2.0)
	fish_velocity = randf_range(-20, 20)
	$Control/TextureProgressBar.value = progress



func _on_fish_update_timer_timeout() -> void:
	fish_velocity = randf_range(-20, 20)
	$FishUpdateTimer.wait_time = randf_range(1, 3)

func raise_bar():
	var target_y = $BarSprite.position.y - 25
	target_y = clamp(target_y, -y_range / 2.0 + 15.0, y_range / 2.0 - 15.0)
	var tween = create_tween()
	tween.tween_property($BarSprite, "position:y", target_y, 0.2)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value <= 0 or value >= 100:
		hide()
		progress = 30.0
		$Control/TextureProgressBar.value = progress
		get_parent().stop_fishing()

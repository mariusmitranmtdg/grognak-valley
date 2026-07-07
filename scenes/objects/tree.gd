extends StaticBody2D

const apple_texture = preload("res://graphics/plants/apple.png")
var hp := 3:
	set(value):
		hp = value
		if hp <= 0:
			$FlashSprite2D.hide()
			$Sprite2D.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12, 6)
			$CollisionShape2D.shape = shape
			$CollisionShape2D.position.y += 8
			

func _ready() -> void:
	create_apples(3)

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		$FlashSprite2D.flash()
		get_apple()
		hp -= 1

func get_apple():
	if $Apples.get_children():
		$Apples.get_children().pick_random().queue_free()

func create_apples(num: int):
	var apple_markers = $ApplePos.get_children().duplicate(true)
	for i in num:
		var cur_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture
		$Apples.add_child(sprite)
		sprite.position = cur_marker.position

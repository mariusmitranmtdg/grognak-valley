extends CharacterBody2D

var player: CharacterBody2D
var dir: Vector2i
var direction_frame = {
	Vector2i(0,1): 0,
	Vector2i(-1,0): 1,
	Vector2i(1,0): 2,
	Vector2i(0,-1): 3,
	Vector2i(1, 1): 2,
	Vector2i(-1, -1): 1,
	Vector2i(1, -1): 2,
	Vector2i(-1, 1): 1
}

@export var dialog: Array[String]
@export var etexture: Texture2D
var dialog_index := 0

func _process(delta: float) -> void:
	if player:
		if player.position.distance_to(position) > 30:
			$Dialog.hide()
			dialog_index = 0

func interact(player_character: CharacterBody2D):
	player = player_character
	var raw_dir = (player.position - position).normalized()
	dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Sprite2D.frame_coords.y = direction_frame[dir]
	$Dialog.show()
	if dialog_index < dialog.size():
		$Dialog.set_text(dialog[dialog_index])
		dialog_index += 1
	else:
		$Dialog.hide()
		dialog_index = 0

func _ready() -> void:
	$Sprite2D.texture = etexture

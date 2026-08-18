class_name Machine extends StaticBody2D

var coord: Vector2i

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	coord = Vector2i(floori(float(pos.x) / Data.TILE_SIZE), floori(float(pos.y) / Data.TILE_SIZE))
	position = pos
	parent.add_child(self)
	print(pos)

func delete(delete_coord):
	if delete_coord == coord:
		queue_free()

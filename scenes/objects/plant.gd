extends StaticBody2D

var coord: Vector2i

func setup(grid_coord: Vector2i, parent: Node2D):
	var salurrr = Vector2i (floor(grid_coord.x/Data.TILE_SIZE), floor(grid_coord.y/Data.TILE_SIZE))
	position = grid_coord * Data.TILE_SIZE + Vector2i(8, -5)
	print(salurrr)
	parent.add_child(self)
	coord = grid_coord

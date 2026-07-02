extends Node2D

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i (floor(pos.x/Data.TILE_SIZE), floor(pos.y/Data.TILE_SIZE))
	
	match tool:
		Enum.Tool.HOE:
			$Layers/SoilMapLayer.set_cells_terrain_connect([grid_coord], 0, 0)
			print(pos, grid_coord)

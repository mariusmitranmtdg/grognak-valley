extends Node2D

var plant_scene = preload("res://scenes/objects/plant.tscn")
var used_cells: Array[Vector2i]

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i (pos.x/Data.TILE_SIZE, pos.y/Data.TILE_SIZE)
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = grid_coord in $Layers/SoilMapLayer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = $Layers/GrassMapLayer.get_cell_tile_data(grid_coord) as TileData
			if cell:
				if cell.get_custom_data('farmable'):
					$Layers/SoilMapLayer.set_cells_terrain_connect([grid_coord], 0, 0)
			print(pos, grid_coord)
		Enum.Tool.WATER:
			if has_soil:
				$Layers/WateredSoilMapLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0, 2), 0))
				pass
		Enum.Tool.FISH:
			if not grid_coord in $Layers/GrassMapLayer.get_used_cells():
				print('peste!')
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord, $Objects)
				used_cells.append(grid_coord)
		Enum.Tool.AXE:
			for object in get_tree().get_nodes_in_group('Objects'):
				print(object.position.distance_to(pos))
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
		Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('ObjectsS'):
				print(object.position.distance_to(pos))
				if object.position.distance_to(pos) < 20:
					object.hit(tool)

extends Node2D

var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/ui/plant_info.tscn")
var raining: bool:
	set(value):
		raining = value
		$Layers/Particles/GPUParticles2D.emitting = value
		$Layers/Particles/GPUParticles2D2.emitting = value
var used_cells: Array[Vector2i]
var projectile_scene = preload("res://scenes/machines/projectile.tscn")

@export var rain_color: Color
@export var daytime_color: Gradient
@onready var daytransition_material = $Overlay/CanvasLayer/DayTransitionLayer.material

signal day_restarted()

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
					if raining:
						$Layers/WateredSoilMapLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0, 2), 0))
			print(pos, grid_coord)
		Enum.Tool.WATER:
			if has_soil:
				$Layers/WateredSoilMapLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0, 2), 0))
				pass
		Enum.Tool.FISH:
			if not grid_coord in $Layers/GrassMapLayer.get_used_cells():
				$Objects/Player.start_fishing()
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant_res = PlantResource.new()
				plant_res.setup($Objects/Player.current_seed)
				var plant = plant_scene.instantiate()
				plant.death.connect(_on_plant_death)
				plant.setup(grid_coord, $Objects, plant_res)
				used_cells.append(grid_coord)
				
				var plant_info = plant_info_scene.instantiate()
				plant_info.setup(plant_res)
				$Overlay/CanvasLayer/PlantInfoContainer.add(plant_info)
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

func _ready() -> void:
	Data.forecast_rain = [true, false].pick_random()
	$Scarecrow.connect("shoot_projectile", create_projectile)

func _process(_delta: float) -> void:
	var daytime_point = 1 - ($Timers/DayTimer.time_left / $Timers/DayTimer.wait_time)
	var color: Color
	
	if raining:
		color = daytime_color.sample(daytime_point).lerp(rain_color, 0.5)
	else:
		color = daytime_color.sample(daytime_point)
	$Overlay/DayTimeColor.color = color
	


func day_restart():
	var tween = create_tween()
	tween.tween_property(daytransition_material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(daytransition_material, "shader_parameter/progress", 0.0, 1.0)

func level_reset():
	day_restarted.emit()
	$Timers/DayTimer.start()
	for plant in get_tree().get_nodes_in_group("Plants"):
		plant.grow(plant.coord in $Layers/WateredSoilMapLayer.get_used_cells())
	$Layers/WateredSoilMapLayer.clear()
	$Overlay/CanvasLayer/PlantInfoContainer.update_all()
	raining = Data.forecast_rain
	Data.forecast_rain = [true, false].pick_random()
	print("rain" if Data.forecast_rain else "sunny")
	if raining:
		for cell in $Layers/SoilMapLayer.get_used_cells():
			$Layers/WateredSoilMapLayer.set_cell(cell, 0, Vector2i(randi_range(0, 2), 0))


func _on_plant_death(coord: Vector2i):
	used_cells.erase(coord)
	


func _on_player_diagnose() -> void:
	$Overlay/CanvasLayer/PlantInfoContainer.visible = not $Overlay/CanvasLayer/PlantInfoContainer.visible


func _on_player_day_change() -> void:
	day_restart()

func create_projectile(start_pos: Vector2, dir: Vector2):
	pass
	var projectile = projectile_scene.instantiate()
	projectile.setup(start_pos, dir)
	$Objects.add_child(projectile)

extends PanelContainer

var res: PlantResource

func setup(plant_res: PlantResource):
	res = plant_res
	$HBoxContainer/VBoxContainer/Name.text = res.name
	$HBoxContainer/Icon.texture = res.icon_texture
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = res.h_frames
	$HBoxContainer/VBoxContainer/GrowthBar.value = res.age
	$HBoxContainer/VBoxContainer/DeathBar.max_value = res.death_max
	$HBoxContainer/VBoxContainer/DeathBar.value = res.death_count
	res.connect("changed", death)



func update():
	$HBoxContainer/VBoxContainer/GrowthBar.value = res.age
	$HBoxContainer/VBoxContainer/DeathBar.value = res.death_count

func death():
	queue_free()

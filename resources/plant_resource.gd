class_name PlantResource extends Resource

@export var texture: Texture2D
@export var icon_texture: Texture2D
@export var name: String
@export var grow_speed: float = 1.0
@export var h_frames: int = 3
@export var death_max: int = 3

var age: float
var death_count: int:
	set(value):
		death_count = value
		emit_changed()
var is_dead: bool:
	set(value):
		is_dead = value
		emit_changed()


func setup(seed_enum: Enum.Seed):
	texture = load(Data.PLANT_DATA[seed_enum]["texture"])
	icon_texture = load(Data.PLANT_DATA[seed_enum]["icon_texture"])
	name = Data.PLANT_DATA[seed_enum]["name"]
	grow_speed = Data.PLANT_DATA[seed_enum]["grow_speed"]
	h_frames = Data.PLANT_DATA[seed_enum]["h_frames"]
	death_max = Data.PLANT_DATA[seed_enum]["death_max"]

func damage():
	death_count += 1

func grow(sprite: Sprite2D):
	age += grow_speed
	sprite.frame = min(int(age), h_frames)
	death_count = 0

func decay(plant: StaticBody2D):
	death_count += 1
	if death_count > death_max:
		plant.death.emit(plant.coord)
		plant.queue_free()
		is_dead = true

func get_complete():
	return age >= h_frames

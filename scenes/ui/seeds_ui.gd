extends Control


const SEED_TEXTURES = {
	Enum.Seed.CORN: preload("res://graphics/icons/corn.png"),
	Enum.Seed.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Enum.Seed.TOMATO: preload("res://graphics/icons/tomato.png"),
	Enum.Seed.WHEAT: preload("res://graphics/icons/wheat.png")}

@onready var tool_texture_scene = preload("res://scenes/ui/tool_ui_texture.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ToolContainer.hide()
	texture_setup(Enum.Seed.values(), SEED_TEXTURES, $ToolContainer)

func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)
		

func _process(_delta: float) -> void:
	pass

func reveal():
	$ToolContainer.show()
	$HideTimer.start()
	var target = get_parent().current_seed
	for texture in $ToolContainer.get_children():
		texture.highlight(target == texture.tool_enum)

func _on_hide_timer_timeout() -> void:
	$ToolContainer.hide()

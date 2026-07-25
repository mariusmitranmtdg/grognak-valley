extends Control


# Called when the node enters the scene tree for the first time.
func add(child: PanelContainer):
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(child)

func update_all():
	print("dau update all")
	for panel in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		panel.update()

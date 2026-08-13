extends StaticBody2D

func interact(body: CharacterBody2D):
	body.day_change.emit()

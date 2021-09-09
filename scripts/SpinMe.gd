extends Spatial

func _physics_process(delta):
	rotation.y += delta / 2;

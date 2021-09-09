extends Spatial

func _ready():
	$Pivot/AnimationPlayer.play("Float");

func _process(delta):
	$Pivot/MeshInstance.rotation_degrees.y += delta * 200;

func _collided(body):
	if(body.name != "StaticBody"): #ignore collisions with level
		hide();
		$Pivot/MeshInstance/Area/CollisionShape.set_deferred("disabled", true)
		body.collectscorething();
	

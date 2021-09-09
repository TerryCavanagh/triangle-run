extends Spatial

var canvas;

func _ready():
	$Pivot/AnimationPlayer.play("Float");
	canvas = get_node("/root/").get_node("Main").get_node("CanvasLayer");

func _process(delta):
	$Pivot/MeshInstance.rotation_degrees.y += delta * 200;

func wait(t):
	yield(get_tree().create_timer(t), "timeout")

func _collided(body):
	if(body.name != "StaticBody"): #ignore collisions with level
		hide();
		$Pivot/MeshInstance/Area/CollisionShape.set_deferred("disabled", true)
		body.collectcheckpoint(body.translation);
		canvas.get_node("ColorRect").visible = true;
		canvas.get_node("AnimationPlayer").play("ScreenFlash");
		
		canvas.get_node("Message").text = "CHECKPOINT";
		canvas.get_node("Message").visible = true;
		yield(get_tree().create_timer(1.5), "timeout")
		canvas.get_node("Message").visible = false;
		
	

extends KinematicBody2D

var sixteensteps = 0

func _process(delta):
	#Animation!
	$Sprite.frame = 1 + (sixteensteps % 2);


func _on_AnimationTick_timeout():
	sixteensteps = (sixteensteps + 1) % 16 

extends KinematicBody2D

export var speed = 100;
export var startframe = 3;
var is_moving = false;
var screen_size;
var sixteensteps = 0;
var dir = 0;
var lastcolour = 0;

func _ready():
	screen_size = get_viewport_rect().size;

func _process(delta):
	var velocity = Vector2();
	var AI = $EnemyAI;
	
	#is_moving = AI.;
	#if Input.is_action_pressed("ui_left"):
	#	velocity.x -= 1;
	#if Input.is_action_pressed("ui_right"):
	#	velocity.x += 1;
	#if Input.is_action_pressed("ui_up"):
	#	velocity.y -= 1;
	#if Input.is_action_pressed("ui_down"):
	#	velocity.y += 1;
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		is_moving = true;
		
	#position += velocity * delta;
	#position.x = clamp(position.x, 0, screen_size.x);
	#position.y = clamp(position.y, 0, screen_size.y);
	
	#Animation!
	if is_moving:
		$Sprite.frame = startframe + 1 + (sixteensteps % 2);
	else:
		$Sprite.frame = startframe;
		
	if velocity.x < 0:
		$Sprite.flip_h = true;
	elif velocity.x > 0:
		$Sprite.flip_h = false;
		
	#Colour!
	lastcolour += delta / 5;
	if lastcolour > 1:
		lastcolour -= 1;
	
	lastcolour = 0.0;
	$Sprite.self_modulate = Color.from_hsv(lastcolour, 0.8, 0.9, 1);

func _on_AnimationTick_timeout():
	sixteensteps = (sixteensteps + 1) % 16;

extends KinematicBody2D

enum ENEMYTYPE { Square, Circle, Triangle, Pentagon, Line, Hexagon }

export(ENEMYTYPE) var type = ENEMYTYPE.Square;
var speed = 15;
var startframe = 3;
var is_moving = false;
var screen_size;
var sixteensteps = 0;
var dir = 0;
var lastcolour = 0;
var enemycolour = Color(1, 1, 1);

func _ready():
	screen_size = get_viewport_rect().size;
	
	match type:
		ENEMYTYPE.Hexagon:
			speed = 15;
			startframe = 0;
			enemycolour = Color(1, 1, 1);
		ENEMYTYPE.Square:
			speed = 15;
			startframe = 3;
			enemycolour = Color(1, 0, 0);
		ENEMYTYPE.Triangle:
			speed = 15;
			startframe = 0;
			enemycolour = Color(1, 1, 0);
		ENEMYTYPE.Circle:
			speed = 15;
			startframe = 6;
			enemycolour = Color(0, 0.5, 1);
		ENEMYTYPE.Pentagon:
			speed = 15;
			startframe = 10;
			enemycolour = Color(1, 0, 1);
		ENEMYTYPE.Line:
			speed = 15;
			startframe = 13;
			enemycolour = Color(0, 1, 0);
			

func _process(delta):
	var velocity = Vector2();
	var AI = $EnemyAI;
	
	is_moving = AI.move;
	if is_moving:
		velocity.x = AI.xdir;
		velocity.y = AI.ydir;

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		is_moving = true;
		
	position += velocity * delta;
	position.x = clamp(position.x, 0, screen_size.x);
	position.y = clamp(position.y, 0, screen_size.y);
	
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
	#$Sprite.self_modulate = Color.from_hsv(lastcolour, 0.8, 0.9, 1);
	$Sprite.self_modulate = enemycolour;

func _on_AnimationTick_timeout():
	sixteensteps = (sixteensteps + 1) % 16;

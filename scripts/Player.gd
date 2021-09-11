extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 25
# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75
export var jumpforce = 20
var gravity = 0.98
var y_velocity = 0;
const MAX_FALL_SPEED = 30

var coyotetime = 0;
var wait_for_land = false;
var jumpqueued = 0;
var lives = 3;
var score = 0;
var playermaterial = null;
var lastcolour = 0.0;

var currentcheckpoint = 0;
var lastcheckpoint = 0;

var moving = false;

var canvas;
var main;

var last_checkpoint_position = Vector3();
var velocity = Vector3.ZERO

func updatelives():
	canvas.get_node("Lives").text = "Lives: " + str(lives)

func updatecolor(delta):
	if playermaterial == null:
		playermaterial = $Pivot/TwirlPivot/MeshInstance.get_surface_material(0);
	
	if main.personalbestunlocked:
		lastcolour += delta;
		if lastcolour > 1:
			lastcolour -= 1;
		#playermaterial.albedo_color = Color.from_hsv(lastcolour, 0.9, 0.8, 1);
		
		playermaterial.albedo_color = Color(0.9, 0.6, 0.85);
		canvas.get_node("PersonalBest").self_modulate = Color.from_hsv(lastcolour, 0.9, 0.95, 1);
	else:
		playermaterial.albedo_color = Color(0, 1, 1);

func updatescore():
	if main.personalbest > 0:
		if score > main.personalbest:
			main.personalbest = score;
			if !main.personalbestunlocked:
				main.get_node("AnimationPlayer").play("SwitchSong");
				main.personalbestunlocked = true;
				$PlayerAudio/PersonalBest.play();
				canvas.get_node("AnimationPlayer").play("ScreenFlash");
				canvas.get_node("PersonalBest").text = "PERSONAL BEST";
				canvas.get_node("PersonalBest").visible = true;
				main.get_node("WorldEnviornment").get_environment().adjustment_enabled = true;
		else:
			if main.personalbest - score < 2000:
				canvas.get_node("PersonalBest").visible = true;
				canvas.get_node("PersonalBest").self_modulate = Color(1, 1, 0);
				canvas.get_node("PersonalBest").text = "PERSONAL BEST IN " + str(main.personalbest - score);
				
	
	canvas.get_node("Score").text = "Score: " + str(score)
	
func gameovermessage():
	canvas.get_node("Lives").text = "Lives: " + str(lives)
	canvas.get_node("ColorRect").visible = true;
	canvas.get_node("AnimationPlayer").play("ScreenFlash");
	
	canvas.get_node("Message").text = "GAME OVER";
	canvas.get_node("Message").visible = true;
	yield(get_tree().create_timer(1.5), "timeout")
	canvas.get_node("Message").visible = false;
	
func hidetitlescreen():
	canvas.get_node("Titlescreen").visible = false;
	canvas.get_node("Lives").visible = true;
	canvas.get_node("Score").visible = true;
	
	$ScoreTimer.start();
	#canvas.get_node("AnimationPlayer").play("ScreenFlash");


func showtitlescreen():
	canvas.get_node("Titlescreen").visible = true;
	canvas.get_node("Lives").visible = false;
	canvas.get_node("Score").visible = false;
	canvas.get_node("PersonalBest").visible = false;

func _ready():
	$Pivot/AnimationPlayer.play("Idle");
	wait_for_land = false;
	jumpqueued = 0;
	coyotetime = 0;
	main = get_node("/root/").get_node("Main");
	canvas = get_node("/root/").get_node("Main").get_node("CanvasLayer");
	translation.z = -2;

func _physics_process(delta):
	updatecolor(delta);
	if(moving):
		# We create a local variable to store the input direction.
		var direction = Vector3.ZERO

		# We check for each move input and update the direction accordingly.
		if Input.is_action_pressed("right"):
			direction.x += 1
		if Input.is_action_pressed("left"):
			direction.x -= 1
		#if Input.is_action_pressed("backwards"):
		#	direction.z += 1
		#if Input.is_action_pressed("forwards"):
		#	direction.z -= 1
		
		direction.z -= 1;
		
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			$Pivot.look_at(translation + direction, Vector3.UP)
		
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y = y_velocity;
		
		velocity.y -= fall_acceleration * delta
		velocity = move_and_slide(velocity, Vector3.UP)
		
		var grounded = is_on_floor()
		if grounded:
			coyotetime = 0.2;
		else:
			if coyotetime > 0:
				coyotetime -= delta;
				if coyotetime < 0:
					coyotetime = 0;
					
		if Input.is_action_just_pressed("jump"):
			jumpqueued = 0.1;
		else:
			if jumpqueued > 0:
				jumpqueued -= delta;
				if jumpqueued < 0:
					jumpqueued = 0;
		
		y_velocity -= gravity
		#var just_jumped = false
		if coyotetime > 0 and (jumpqueued > 0 or Input.is_action_pressed("jump")):
			#just_jumped = true
			coyotetime = 0;
			y_velocity = jumpforce
			
			$PlayerAudio/Jump.play();
			$Pivot/AnimationPlayer.play("Jump");
		if grounded and y_velocity <= 0:
			y_velocity = -0.1
		if y_velocity < -MAX_FALL_SPEED:
			y_velocity = -MAX_FALL_SPEED
			
		#canvas.get_node("Text").Message = "jumpqueued: " + str(jumpqueued)
		#canvas.get_node("Text").self_modulate = Color(1, 1, 0)
			
		if wait_for_land:
			if grounded:
				$Pivot/AnimationPlayer.play("Land");
				wait_for_land = false;

func lookatcamera():
	$Pivot.look_at(translation + Vector3(0,0, PI/2), Vector3.UP);

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Jump":
		wait_for_land = true;
	elif anim_name == "Land":
		$Pivot/AnimationPlayer.play("Idle");
		
func collectscorething():
	$PlayerAudio/Pickup.play();
	score += 100;
	updatescore();
	
func collectcheckpoint(checkpoint_position):
	last_checkpoint_position = checkpoint_position;
	$PlayerAudio/Checkpoint.play();
	score += 1000;
	currentcheckpoint += 1;
	if(lastcheckpoint - currentcheckpoint >= 2):
		main.generatemore();
	updatescore();
	

func _on_ScoreTimer_timeout():
	if(moving and !main.gameover):
		score += 1;
		updatescore();
	

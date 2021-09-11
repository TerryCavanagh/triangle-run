extends Node

export(Array, PackedScene) var floor_basics
export(Array, PackedScene) var floor_simple_easy
export(Array, PackedScene) var floor_simple
export(Array, PackedScene) var floor_medium_easy
export(Array, PackedScene) var floor_medium
export(Array, PackedScene) var floor_long_easy
export(Array, PackedScene) var floor_long
export(Array, PackedScene) var floor_huge_easy
export(Array, PackedScene) var floor_huge
export(PackedScene) var floor_checkpoint

export(PackedScene) var playerscene;

var levelhistory = [];

var player = null;

var cursor = 0;
var debuglevels = false;
var gameover = false;

func moveplayertolastcheckpoint():
	player.lives -= 1;
	if(player.lives > 0):
		player.updatelives()
		player.translation = player.last_checkpoint_position
	else:
		$AnimationPlayer.play("MusicFadeOut");
		player.gameovermessage();
		player.hide();
		gameover = true;
		yield(get_tree().create_timer(3), "timeout")
		restartgame();
		player.last_checkpoint_position = Vector3();
		
	#movingplayer = true;

func restartgame():
	player.showtitlescreen();
	spawnplayer();
	cleanuplevel();
	
	player.currentcheckpoint = 0;
	player.lastcheckpoint = 0;
	player.score = 0;
	player.lives = 3;
	player.moving = false;
	player.updatelives();
	player.lookatcamera();
	gameover = false;
	
	randomize();
	cursor = 0;
	randomizelevel();
	
func cleanuplevel():
	for e in levelhistory:
		remove_child(e);
		e.free();
		
	levelhistory = [];

func do_returnplayertocheckpoint():
	pass

func spawnplayer():
	if player != null:
		remove_child(player)
		player.free()
	
	player = playerscene.instance();
	add_child(player);

func placegap(size):
	cursor += -5.6 * size;

func placesection(floorpiece, cursoroverride = 5.6):
	var floorsection = floorpiece.instance();
	floorsection.translation.z = cursor;
	
	var maxlength = 0.0;
	if(cursoroverride == 0):
		#Figure out the length of the piece
		#not working, fuck it just hack around it
		for child in floorsection.get_children():
			var length = child.scale.z * 2;
			if(length > maxlength):
				maxlength = length;
	else:
		maxlength = cursoroverride;
		
	cursor += -maxlength;
	levelhistory.push_back(floorsection);
	add_child(floorsection);
	
func pick(arr):
	return arr[randi() % arr.size()];
	
func place(type, amount = 0.0):
	match(type):
		"checkpoint":
			placesection(floor_checkpoint, 44.8);
			player.lastcheckpoint += 1;
		"opening":
			placesection(floor_basics[6]);
			placesection(floor_basics[6]);
			placesection(floor_basics[6]);
			placesection(floor_basics[6]);
			placesection(floor_basics[6]);
		"gap":
			placegap(amount);
		"noise":
			for i in amount:
				placesection(pick(floor_basics));
		"simple":
			placesection(pick(floor_simple));
		"medium_easy":
			placesection(pick(floor_medium_easy), 11.2);
		"medium":
			placesection(pick(floor_medium), 11.2);
			place("gap", 1);
			placesection(pick(floor_medium), 11.2);
			place("gap", 1);
			placesection(pick(floor_medium), 11.2);
		"long_easy":
			placesection(pick(floor_long_easy), 22.4);
		"long":
			placesection(pick(floor_long), 22.4);
		"huge_easy":
			placesection(pick(floor_huge_easy), 44.8);
		"huge":
			placesection(pick(floor_huge), 44.8);


func createlevel(intensity):
	match(intensity):
		1: #1 is kinda boring, just start at 2
			for i in 2:
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("medium");
				place("gap", 2);
				place("noise", 10);
		2:
			for i in 2:
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("noise", 2);
				place("long_easy");
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("medium");
		3:
			for i in 1:
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("long_easy");
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("noise", 1);
		4:
			for i in 1:
				place("gap", 2);
				place("long_easy");
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("long_easy");
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("huge_easy");
				place("gap", 2);
				place("noise", 4);
		5:
			for i in 1:
				place("gap", 2);
				place("long_easy");
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("noise", 4);
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("huge_easy");
				place("gap", 2);
				place("noise", 4);
				place("gap", 2);
				place("huge");
				place("gap", 2);
				place("noise", 4);
		6:
			for i in 1:
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("noise", 2);
				place("gap", 2);
				place("huge_easy");
				place("gap", 2);
				place("huge");
		7:
			for i in 1:
				place("gap", 2);
				place("simple");
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("noise", 1);
				place("gap", 2);
				place("huge");
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("huge");		
		8:
			for i in 4:
				place("gap", 2);
				place("long");
				place("gap", 2);
				place("huge");

func debugsection():
	debuglevels = true;
	place("opening");
	place("gap", 2);
	place("checkpoint");
	
	place("noise", 10);
	place("gap", 2);
	placesection(floor_long[3], 22.4);
	place("gap", 2);
	place("noise", 10);
	place("gap", 2);
	placesection(floor_long[3], 22.4);
	place("gap", 2);
	place("noise", 10);
	place("gap", 2);
	placesection(floor_long[3], 22.4);
	place("gap", 2);
	place("noise", 10);
	place("gap", 2);
	placesection(floor_long[5], 22.4);
	place("gap", 2);
	

func randomizelevel():
	debugsection();
	return;
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(2);
	place("gap", 2);
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(3);
	place("gap", 2);
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(4);
	place("gap", 2);
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(5);
	place("gap", 2);
	
	generatemore();

func generatemore():
	if debuglevels: 
		return;
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(6);
	place("gap", 2);
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(7);
	place("gap", 2);
	
	place("opening");
	place("gap", 2);
	place("checkpoint");
	createlevel(8);
	place("gap", 2);

func mute():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10000);
	pass;

func _ready():
	mute();
	randomize();
	
	spawnplayer();
	player.lookatcamera();
	player.moving = false;
	cursor = 0;
	randomizelevel();

func _physics_process(delta):
	if(!gameover):
		if(!player.moving): #title screen
			if Input.is_action_just_pressed("jump"):
				$Audio/Music.volume_db = 0;
				$Audio/Music.play();
				player.hidetitlescreen();
				player.show();
				player.moving = true;
			
		if Input.is_action_just_pressed("restart"):
			$Audio/Crash.play();
			moveplayertolastcheckpoint();
		
		if(player != null):
			if(player.translation.y <= -10):
				$Audio/Crash.play();
				moveplayertolastcheckpoint();
	else:
		#restart the game
		pass

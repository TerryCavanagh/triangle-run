extends Node

enum ENEMYTYPE { Nothing, Wander }
export(ENEMYTYPE) var AIType

var waitdelay = 1;

var move = false;
var xdir = 0;
var ydir = 0;

func _ready():
	match AIType:
		ENEMYTYPE.Nothing:
			pass;
		ENEMYTYPE.Wander:
			waitdelay = rand_range(0.5, 2);
			move = false;
	
	$AITimer.wait_time = waitdelay;
	$AITimer.start();
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func pick(arr):
	return arr[randi() % arr.size()]


func _on_AITimer_timeout():
	match AIType:
		ENEMYTYPE.Nothing:
			pass
		ENEMYTYPE.Wander:
			if move:
				waitdelay = 1.5;
				xdir = 0; ydir = 0;
				move = false;
				$AITimer.wait_time = waitdelay;
			else:
				waitdelay = 1;
				xdir = rand_range(-100, 100);
				ydir = rand_range(-100, 100);
				move = true;
				$AITimer.wait_time = waitdelay;
	$AITimer.start();

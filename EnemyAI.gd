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
			waitdelay = 1;
			move = false;
	
	$AITimer.wait_time = waitdelay;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func pick(arr):
	return arr[randi() % arr.size()]


func _on_AITimer_timeout():
	print("bing!")
	match AIType:
		ENEMYTYPE.Nothing:
			pass
		ENEMYTYPE.Wander:
			if move:
				waitdelay = 2;
				xdir = 0; ydir = 0;
				move = false;
				$AITimer.wait_time = waitdelay;
			else:
				waitdelay = 1;
				xdir = pick([-1, 1]);
				ydir = 0;
				move = true;
				$AITimer.wait_time = waitdelay;

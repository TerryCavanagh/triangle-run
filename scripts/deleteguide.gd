extends Spatial

func _ready():
	$Guide.visible = false;
	
	var scorecount = 0;
	
	#If there's a scorething in this section, then have it appear with
	#50/50 odds. If there's more than one, they should always appear.
	for e in get_children():
		if(e.name == "ScoreThing"):
			scorecount += 1;
		elif(e.name == "ScoreThing2"): #kludge game jams are stressful
			scorecount += 1;
	
	if(scorecount == 1):
		for e in get_children():
			if(e.name == "ScoreThing"):
				if(rand_range(0, 100) > 50):
					e.free();
	

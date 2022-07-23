extends State


func enter(arg = {}):
	pass


export(float) var check_for_player_every_t := 2.0
var next_check_for_player: float


func process(delta):
	if not next_check_for_player:
		next_check_for_player = check_for_player_every_t
	elif next_check_for_player <= 0:
		machine.transit("CheckForPlayer")
	else:
		next_check_for_player -= delta

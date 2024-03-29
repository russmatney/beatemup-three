extends State

## enter ###########################################################


func enter(arg = {}):
	owner.animated_sprite.animation = "idle"


## process ###########################################################

export(float) var check_for_player_every_t := 1.0
var next_check_for_player: float


func check_for_player():
	for node in owner.in_detectbox:
		if node.is_in_group("player"):
			transit("Approach", {"player": node})
			return


func ai_process(delta):
	if not next_check_for_player:
		next_check_for_player = check_for_player_every_t
	elif next_check_for_player <= 0:
		check_for_player()
	else:
		next_check_for_player -= delta


# TODO maybe we extend State with a CharState that does this
func process(delta):
	if not owner.is_player:
		ai_process(delta)


## physics ###########################################################


func physics_process(delta):
	if owner.is_player:
		player_physics_process(delta)


func player_physics_process(_delta):
	if Trolley.move_dir().length() > 0.1:
		transit("Walk")


## input ###########################################################


func handle_input(event):
	if owner.is_player and Trolley.is_attack(event):
		transit("Attack")

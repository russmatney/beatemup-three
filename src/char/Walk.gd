extends State

## enter ###########################################################


func enter(_arg = {}):
	owner.animated_sprite.animation = "walk"


## process ###########################################################


func process(_delta: float):
	owner.face(Trolley.move_dir())


## physics ###########################################################


func physics_process(delta: float):
	var move_dir = Trolley.move_dir()
	if move_dir.length() >= 0.1:
		owner.walk(move_dir, delta)
	else:
		# maybe check if enemy in punchbox -> DukesUp ?
		transit("Idle")


## input ###########################################################


func handle_input(event):
	if owner.is_player and Trolley.is_attack(event):
		transit("Attack")

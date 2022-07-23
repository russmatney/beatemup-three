extends State

## enter ###########################################################

var delay_idle_transit = 1.5
var until_idle_transit


func enter(arg = {}):
	until_idle_transit = arg.get("delay_idle", delay_idle_transit)
	owner.animated_sprite.animation = "dukes_up"


## process ###########################################################

# TODO make random?
var attack_every_t = 0.5
var until_next_attack


func ai_process(delta: float):
	# TODO deal with no-owner? (target dead)
	if not owner.target in owner.in_punchbox:
		transit("Approach", {"delay": 0.3})

	if not until_next_attack:
		until_next_attack = attack_every_t
	elif until_next_attack <= 0:
		transit("Attack")
		until_next_attack = attack_every_t
	else:
		until_next_attack -= delta


func process(delta):
	if not owner.is_player:
		ai_process(delta)


## physics ###########################################################


func physics_process(delta):
	if owner.is_player:
		if Trolley.move_dir().length() > 0.1:
			transit("Walk")

	if owner.in_punchbox.size() == 0:
		if not until_idle_transit:
			until_idle_transit = delay_idle_transit
		elif until_idle_transit <= 0:
			transit("Idle")
		else:
			until_idle_transit -= delta


## input ###########################################################


func handle_input(event):
	if owner.is_player and Trolley.is_attack(event):
		transit("Attack")

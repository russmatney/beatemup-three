extends State


# could get attack-in, last attack-at, etc
func enter(_arg = {}):
	owner.animated_sprite.animation = "dukes_up"


# TODO should be somewhat random
var attack_every_t = 0.5
var until_next_attack


func process(delta: float):
	# TODO deal with no-owner (target dead)
	if not owner.target in owner.in_punchbox:
		transit("Approach", {"delay": 0.3})

	if not until_next_attack:
		until_next_attack = attack_every_t
	elif until_next_attack <= 0:
		transit("Attack")
		until_next_attack = attack_every_t
	else:
		until_next_attack -= delta

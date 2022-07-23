extends State


func enter(msg = {}):
	# TODO this delay should be a bit random, may depend on the char
	# probably want to attack with combos, not just paced attacks
	var delay = msg.get("delay", 0.5)

	# not sure this is a great way to handle a state
	# but it should at least stop them moving
	yield(get_tree().create_timer(delay), "timeout")

	owner.attack()

	# go round again
	transit("Idle")


func process(_delta: float):
	pass

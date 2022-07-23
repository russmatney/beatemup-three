extends State


func enter(msg = {}):
	var delay = msg.get("delay", 2.0)

	# not sure this is a great way to handle a state
	# but it should at least stop them moving
	yield(get_tree().create_timer(delay), "timeout")

	print("attack-player delay over")

	owner.attack()
	# transition to an attack/wait state?


func process(_delta: float):
	pass
	# owner.approach_target()

	# # TODO probably not quite stable
	# # might want to get a bit closer first
	# if owner.target in owner.in_punchbox:
	# 	machine.transit("Attack", {"delay": 2.0})

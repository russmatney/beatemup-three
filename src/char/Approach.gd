extends State


func enter(msg = {}):
	var player = msg.get("player")

	owner.assign_target(player)


func process(_delta: float):
	owner.approach_target()

	# TODO probably not quite stable
	# might want to get a bit closer first
	if owner.target in owner.in_punchbox:
		owner.move_in_dir = Vector2.ZERO
		machine.transit("Attack", {"delay": 2.0})

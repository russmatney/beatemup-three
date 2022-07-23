extends State


func enter(msg = {}):
	var player = msg.get("player")

	if player:
		print("assigning target: ", player)
		owner.assign_target(player)
		owner.face_attacker(player)


func process(_delta: float):
	owner.approach_target()

	# TODO probably not quite stable
	# might want to get a bit closer first
	if owner.target in owner.in_punchbox:
		owner.move_in_dir = Vector2.ZERO
		transit("DukesUp")

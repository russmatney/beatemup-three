extends State


func enter(msg = {}):
	var player = msg.get("player")

	if player:
		print("assigning target: ", player)
		owner.assign_target(player)
		owner.face_attacker(player)


func process(delta: float):
	var move_dir = owner.direction_to_target()
	if move_dir:
		owner.face(move_dir)

	if owner.target in owner.in_punchbox:
		transit("DukesUp")

func physics_process(delta: float):
	var move_dir = owner.direction_to_target()
	if move_dir:
		owner.walk(move_dir, delta)

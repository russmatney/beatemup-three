extends State


func enter(arg = {}):
	# TODO diff stunned/knocked_back, probs with arg
	owner.knocked_back = true

	var force: Vector2 = arg.get("force")
	if force:
		owner.velocity = force

	var time = arg.get("time")

	yield(get_tree().create_timer(time), "timeout")

	owner.knocked_back = false
	machine.transit("Idle")


func process(_delta: float):
	# TODO diff stunned/knocked_back
	if owner.knocked_back:
		owner.animated_sprite.animation = "knocked_back"
	elif owner.stunned:
		owner.animated_sprite.animation = "stunned"

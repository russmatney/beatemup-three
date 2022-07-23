extends State


func enter(msg = {}):
	var force: Vector2 = msg.get("force")
	if force:
		owner.velocity = force

	var time = msg.get("time")

	# not sure this is a great way to handle a state
	# but it should at least stop them moving
	yield(get_tree().create_timer(time), "timeout")

	owner.knocked_back = false
	machine.transit("Idle")


func process(_delta: float):
	owner.knocked_back = true

	if owner.knocked_back:
		owner.animated_sprite.animation = "knocked_back"
	elif owner.stunned:
		owner.animated_sprite.animation = "stunned"

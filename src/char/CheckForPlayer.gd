extends State


func enter(msg = {}):
	delay_remaining = msg.get("delay", 0.4)


var delay_remaining


func process(delta: float):
	delay_remaining -= delta

	if delay_remaining <= 0:
		# TODO pause a bit first
		for node in owner.in_detectbox:
			if node.is_in_group("player"):
				transit("Approach", {"player": node})
				return
		transit("Idle")

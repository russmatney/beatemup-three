extends State


func enter(msg = {}):
	delay_remaining = msg.get("delay", 0.4)


var delay_remaining


func process(delta: float):
	delay_remaining -= delta


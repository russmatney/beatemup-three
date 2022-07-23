extends BTConditional

export(float) var threshold = 5

export(float) var y_min_bound = 0
export(float) var y_max_bound = 400
export(float) var x_min_bound = 0
export(float) var x_max_bound = 700


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	var current_position = agent.get_global_position()

	if current_position.y - threshold <= y_min_bound:
		verified = true
	elif current_position.y + threshold >= y_max_bound:
		verified = true
	elif current_position.x - threshold <= x_min_bound:
		verified = true
	elif current_position.x - threshold >= x_max_bound:
		verified = true
	else:
		verified = false

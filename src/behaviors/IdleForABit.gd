extends BTLeaf


func _tick(_agent: Node, _blackboard: Blackboard) -> bool:
	# TODO set 'idle' animation
	yield(get_tree().create_timer(2, false), "timeout")
	return succeed()

extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	agent.face_attacker(agent.target)

	return succeed()

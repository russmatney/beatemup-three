extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert("move_in_dir" in agent)

  agent.move_in_dir = Vector2.ZERO

  return succeed()

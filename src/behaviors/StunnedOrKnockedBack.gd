extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
  verified = agent.stunned or agent.knocked_back

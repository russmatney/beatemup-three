extends BTLeaf

export(float) var threshold = 5

# TODO ugh, shared w/ AtBoundary
export(float) var y_min_bound = 0
export(float) var y_max_bound = 400
export(float) var x_min_bound = 0
export(float) var x_max_bound = 700

# TODO could instead just flip x and y...
# TODO could this get called multiple times, flipping twice?
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert("move_in_dir" in agent)

  var current_position = agent.get_global_position()

  if current_position.y - threshold <= y_min_bound:
    agent.move_in_dir.y *= -1
  elif current_position.y + threshold >= y_max_bound:
    agent.move_in_dir.y *= -1
  elif current_position.x - threshold <= x_min_bound:
    agent.move_in_dir.x *= -1
  elif current_position.x - threshold >= x_max_bound:
    agent.move_in_dir.x *= -1

  return succeed()

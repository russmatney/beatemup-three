extends BTConditional

export(String) var target_group = "char-body"

func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
  assert(target_group)
  assert("in_detectbox" in agent)
  assert("target" in agent)

  print("detects target running", agent)

  if agent.target:
    # agent already has a target, we'll use that instead
    verified = true
    return

  var current_pos = agent.get_global_position()

  var closest_target
  var closest_target_dist
  for ch in agent.in_detectbox:
    print("ch in detectbox", ch)
    if ch.is_in_group(target_group):
      # TODO consider raycast for line-of-sight check
      var dist = current_pos.distance_to(ch.get_global_position())
      if not closest_target_dist or dist < closest_target_dist:
        print("setting closest target dist")
        closest_target = ch
        closest_target_dist = dist
      else:
        print("already something closer?", dist)

  print("checked in_detectbox", closest_target)

  if closest_target:
    agent.target = closest_target
    verified = true
  else:
    verified = false

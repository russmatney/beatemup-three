extends BTLeaf

enum { LEFT, RIGHT }

# this needs to be guarded, or it will kick way too many times
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert(agent.has_method("update_facing"))

  var new_facing = LEFT if agent.facing == RIGHT else RIGHT
  agent.update_facing(new_facing)

  return succeed()

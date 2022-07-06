extends Node2D

onready var tm = $TileMap

var detectors = []
var to_reset = {}
var to_mark = {}

enum {NONE, BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK}

func _pos_to_cell(pos: Vector2) -> Vector2:
  return tm.world_to_map(pos)

func _is_even(i: int) -> bool:
  return fmod(i, 2) == 0

func _process(_delta):
  print("detectors", detectors)
  for detector in detectors:
    if "extents" in detector:
      var first_cell = _pos_to_cell(detector.global_position - detector.extents)
      var last_cell = _pos_to_cell(detector.global_position + detector.extents)
      for x in range(first_cell.x, last_cell.x + 1):
        for y in range(first_cell.y, last_cell.y + 1):
          to_mark[Vector2(x, y)] = true
    else:
      print("detector without extents")
      var cell = _pos_to_cell(detector.global_position)
      to_mark[cell] = true

  for v in to_reset.keys():
    if not to_mark.has(v):
      # reset this cell to blue
      tm.set_cellv(v, BLUE_LIGHT if _is_even(v.x + v.y) else BLUE_DARK)
      to_reset.erase(v)

  for v in to_mark.keys():
    tm.set_cellv(v, RED_LIGHT if _is_even(v.x + v.y) else RED_DARK)
    to_mark.erase(v)
    # store to be reset on the next pass (unless it is marked again)
    to_reset[v] = true

func add_active_body(body):
  detectors.append(body)

func remove_active_body(body):
  detectors.erase(body)

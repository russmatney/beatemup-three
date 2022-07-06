extends Node2D

onready var tm = $TileMap

var detectors = []
var to_reset = {}

enum {NONE, BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK}

func _pos_to_cell(pos: Vector2) -> Vector2:
  return tm.world_to_map(pos)

func _process(_delta):
  var to_mark = {}
  for detector in detectors:
    var det_pos = detector.global_position
    if "extents" in detector:
      var first_cell = _pos_to_cell(detector.global_position - detector.extents)
      var last_cell = _pos_to_cell(detector.global_position + detector.extents)
      for x in range(first_cell.x, last_cell.x + 1):
        for y in range(first_cell.y, last_cell.y + 1):
          to_mark[Vector2(x, y)] = true
    else:
      var cell = _pos_to_cell(detector.global_position)
      to_mark[cell] = true

  for v in to_reset.keys():
    if not to_mark.has(v):
      tm.set_cellv(v, BLUE_LIGHT if fmod(v.x + v.y, 2) == 0 else BLUE_DARK)
      to_reset.erase(v)

  for v in to_mark.keys():
    tm.set_cellv(v, RED_LIGHT if fmod(v.x + v.y, 2) == 0 else RED_DARK)
    to_reset[v] = true

func add_active_body(body):
  detectors.append(body)

func remove_active_body(body):
  detectors.erase(body)

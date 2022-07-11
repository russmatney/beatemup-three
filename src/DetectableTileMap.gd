extends TileMap
class_name DetectableTileMap

# A dictionary by instance_id
var detectors = {}

# cells to reset
var to_reset = {}
# cells to mark active
var to_mark = {}

# correspond to the index of the tiles in the tilemap's tileset
enum {NONE,
    BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK,
    ORANGE_LIGHT, ORANGE_DARK, GREEN_LIGHT, GREEN_DARK}
# convenient for supporting various color types
enum {BLUE, RED, ORANGE, GREEN}

func _is_even(i: int) -> bool:
  return i % 2 == 0

func _process(_delta):
  for detector in detectors.values():
    # TODO check if detector is still alive? (b/c things can die)
    if detector.has_method("overlapping_cells"):
      var cells = detector.overlapping_cells(self)
      var color = detector.mark_color if "mark_color" in detector else RED
      for cell in cells:
          to_mark[cell] = color
    else:
      print("detector without overlapping_cells support!")
      var cell = world_to_map(detector.global_position)
      var color = detector.mark_color if "mark_color" in detector else RED
      to_mark[cell] = color

  for v in to_reset.keys():
    if not to_mark.has(v):
      mark_tile(v, BLUE)
      to_reset.erase(v)

  for v in to_mark.keys():
    mark_tile(v, to_mark[v])
    to_mark.erase(v)
    # store to be reset on the next pass (unless it is marked again)
    to_reset[v] = true

func add_active_body(body):
  detectors[body.get_instance_id()] = body

func remove_active_body(body):
  detectors.erase(body.get_instance_id())

func mark_tile(v: Vector2, color: int = BLUE):
    var colord = color_to_tileset_color(color)
    var new_tile_idx: int = color_for_cell(v, colord["light"], colord["dark"])
    var curr_tile_idx: int = get_cellv(v)
    if curr_tile_idx != new_tile_idx:
      set_cellv(v, new_tile_idx)

func color_for_cell(v: Vector2, light: int, dark: int) -> int:
      return light if _is_even(int(v.x) + int(v.y)) else dark

func color_to_tileset_color(color: int) -> Dictionary:
    match color:
        BLUE:
            return {"light": BLUE_LIGHT, "dark": BLUE_DARK}
        RED:
            return {"light": RED_LIGHT, "dark": RED_DARK}
        ORANGE:
            return {"light": ORANGE_LIGHT, "dark": ORANGE_DARK}
        GREEN:
            return {"light": GREEN_LIGHT, "dark": GREEN_DARK}
    return {}

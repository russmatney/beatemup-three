class_name TileDetector
extends Area2D

# copy-pastaed from SimpleTile.gd
enum {BLUE, RED, ORANGE, GREEN}
var mark_color = RED

func _on_TileDetector_body_entered(body):
  if body is TileMap:
    if body.get_parent().has_method("add_active_body"):
      body.get_parent().add_active_body(self)

# area2ds fire body_exited when tilemap set_cell is called
# https://github.com/godotengine/godot/issues/61220
# func _on_TileDetector_body_exited(body:Node):
#   if body is TileMap:
#     if body.get_parent().has_method("remove_active_body"):
#       body.get_parent().remove_active_body(self)

# Returns an array of vector2s - the overlapping tilemap cell coordinates
func overlapping_cells(tm: TileMap) -> Array:
  # may one day need to support more shapes here
  var extents = $CollisionShape2D.shape.extents
  var first_cell = tm.world_to_map(global_position - extents)
  var last_cell = tm.world_to_map(global_position + extents)
  var cells = []
  for x in range(first_cell.x, last_cell.x + 1):
    for y in range(first_cell.y, last_cell.y + 1):
      cells.append(Vector2(x, y))
  return cells

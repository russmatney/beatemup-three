extends Area2D
# tightly coupled to SimpleTile.gd

onready var extents = null

func _ready():
  if $CollisionShape2D:
    extents = $CollisionShape2D.shape.extents
  else:
    Notif.notif("tile detector ought to know it's own extents!")

func _on_TileDetector_body_entered(body):
  print("body entered")
  if body is TileMap:
    # maybe should add the parent?
    if body.get_parent().has_method("add_active_body"):
      body.get_parent().add_active_body(self)


func _on_TileDetector_body_exited(body:Node):
  print("body exited")
  if body is TileMap:
    # maybe should add the parent?
    if body.get_parent().has_method("remove_active_body"):
      body.get_parent().remove_active_body(self)

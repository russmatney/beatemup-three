extends Area2D
# tightly coupled to SimpleTile.gd


func _on_TileDetector_body_entered(body):
  print("tile detector detects body entered!")
  print(body)

  if body is TileMap:
    print("is tilemap!")

    # maybe should add the parent?
    if body.get_parent().has_method("add_active_body"):
      body.get_parent().add_active_body(self)


func _on_TileDetector_body_exited(body:Node):
  print("tile detector detects body exited!")
  print(body)

  if body is TileMap:
    print("is tilemap!")

    # maybe should add the parent?
    if body.get_parent().has_method("remove_active_body"):
      body.get_parent().remove_active_body(self)

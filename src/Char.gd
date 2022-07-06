extends KinematicBody2D

var velocity = Vector2()
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
  Notif.notif("ready")


func _process(_delta):
  for i in get_slide_count():
    var collision = get_slide_collision(i)
    print("player coll", collision)


func _physics_process(_delta):
  velocity = Trols.move_dir() * speed
  velocity = move_and_slide(velocity)

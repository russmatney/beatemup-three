extends KinematicBody2D

var velocity = Vector2()
var speed = 200

enum face_dir {LEFT, RIGHT}
var facing = face_dir.LEFT

onready var animated_sprite = $AnimatedSprite
onready var facing_detector = $FacingDetector
var facing_detector_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  Notif.notif("ready")
  facing_detector_x = facing_detector.transform.origin.x


func _process(_delta):
  for i in get_slide_count():
    var collision = get_slide_collision(i)
    print("player coll", collision)

  var move_vector: Vector2 = Trols.move_dir()
  if move_vector.x > 0:
    facing = face_dir.LEFT
  elif move_vector.x < 0:
    facing = face_dir.RIGHT

  match facing:
      face_dir.LEFT:
          animated_sprite.flip_h = false
          facing_detector.transform.origin.x = facing_detector_x
      face_dir.RIGHT:
          animated_sprite.flip_h = true
          facing_detector.transform.origin.x = -facing_detector_x

  if move_vector.length() == 0:
    animated_sprite.animation = "idle"
  else:
    animated_sprite.animation = "walk"


func _physics_process(_delta):
  var move_vector = Trols.move_dir()
  velocity = move_vector * speed
  velocity = move_and_slide(velocity)

extends KinematicBody2D

var velocity = Vector2()
var speed = 200

enum face_dir {LEFT, RIGHT}
var facing = face_dir.LEFT

onready var animated_sprite = $AnimatedSprite
onready var facing_detector = $FacingDetector

onready var punchbox = $Punchbox
onready var kickbox = $Kickbox
onready var hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready():
  Notif.notif("ready")

func flip_area(area: Area2D):
  area.transform.origin.x *= -1

func _process(_delta):
  for i in get_slide_count():
    var collision = get_slide_collision(i)
    print("player coll", collision)

  var move_vector: Vector2 = Trols.move_dir()
  var old_facing = facing
  if move_vector.x > 0:
    facing = face_dir.LEFT
  elif move_vector.x < 0:
    facing = face_dir.RIGHT

  if old_facing != facing:
      match facing:
          face_dir.LEFT:
              animated_sprite.flip_h = false
              flip_area(facing_detector)
              flip_area(punchbox)
              flip_area(kickbox)
              flip_area(hurtbox)
          face_dir.RIGHT:
              animated_sprite.flip_h = true
              flip_area(facing_detector)
              flip_area(punchbox)
              flip_area(kickbox)
              flip_area(hurtbox)

  if move_vector.length() == 0:
    animated_sprite.animation = "idle"
  else:
    animated_sprite.animation = "walk"


func _physics_process(_delta):
  var move_vector = Trols.move_dir()
  velocity = move_vector * speed
  velocity = move_and_slide(velocity)

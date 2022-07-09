extends KinematicBody2D

var velocity = Vector2()
var speed = 200

enum face_dir {LEFT, RIGHT}
var facing = face_dir.LEFT

export(bool) var is_player = false

onready var animated_sprite = $AnimatedSprite
onready var facing_detector = $FacingDetector

onready var punchbox = $Punchbox
onready var kickbox = $Kickbox
onready var hurtbox = $Hurtbox

### ready #####################################################################

func _ready():
  Notif.notif("ready")

func get_move_vector():
  return Trols.move_dir() if is_player else Vector2()

### process #####################################################################

func flip_area(area: Area2D):
  area.transform.origin.x *= -1

func _process(_delta):
  for i in get_slide_count():
    var collision = get_slide_collision(i)
    print("player coll", collision)

  var move_vector: Vector2 = get_move_vector()
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

### physics_process #####################################################################

func _physics_process(_delta):
  var move_vector: Vector2 = get_move_vector()
  if not punching and not kicking and not stunned and not knocked_back:
    velocity = move_vector * speed
  velocity = move_and_slide(velocity)

### unhandled_input #####################################################################

func _unhandled_input(event):
  if is_player and Trols.is_attack(event):
    attack()

### combat #####################################################################

var stunned = false
var knocked_back = false

var punch_count = 0
var punching = false
var punch_windup = 0.1
var punch_cooldown = 0.2

var kicking = false
var kick_windup = 0.1
var kick_cooldown = 0.3

var in_punchbox = []
var in_kickbox = []

# TODO add $ComboTimer node
onready var combo_timer = $ComboTimer
export(float) var combo_timeout := 0.5

signal punch
signal kick

func attack():
  # can-attack?
  # punch or kick?
  # cancel attack if hit before/during windup?

  if punch_count >= 2:
    kick()
  else:
    punch()

func can_attack():
  return not stunned and not knocked_back

func punch():
  # TODO cut off with some queue (so we don't wait for the finish before continuing the combo)
  punch_count += 1
  punching = true
  yield(get_tree().create_timer(punch_windup), "timeout")

  if not stunned and not knocked_back:
    emit_signal("punch", self) # maybe just for metrics/ui?

    for ch in in_punchbox:
      print("punching: ", ch)

  yield(get_tree().create_timer(punch_cooldown), "timeout")
  punching = false

func kick():
  punch_count = 0
  kicking = true
  yield(get_tree().create_timer(kick_windup), "timeout")

  if not stunned and not knocked_back:
    emit_signal("kick", self)
    for ch in in_kickbox:
      print("kickbox: ", ch)

  yield(get_tree().create_timer(kick_cooldown), "timeout")
  kicking = false

### hitbox signals ##########################################################

func _on_Punchbox_area_entered(area):
  if area.is_in_group("hurtboxes") and area != hurtbox:
    print("area entered punchbox ", area, " ", area.get_parent())
    in_punchbox.append(area.get_parent())

func _on_Punchbox_area_exited(area):
  in_punchbox.erase(area.get_parent())

func _on_Kickbox_area_entered(area):
  if area.is_in_group("hurtboxes") and area != hurtbox:
    in_kickbox.append(area.get_parent())

func _on_Kickbox_area_exited(area):
  in_kickbox.erase(area.get_parent())

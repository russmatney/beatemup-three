extends KinematicBody2D

var velocity = Vector2()
var speed = 200

var move_in_dir = Vector2()
var patrol_points = []

enum face_dir { LEFT, RIGHT }
var facing = face_dir.LEFT

export(bool) var is_player = false

# some target this agent wants to attack
# assigned in behaviors/DetectsPlayer
var target
onready var attack_slot_a = $AttackSlotA
onready var attack_slot_b = $AttackSlotB
func attack_slots():
  return [attack_slot_a, attack_slot_b]

onready var animated_sprite = $AnimatedSprite
onready var facing_detector = $FacingDetector

onready var punchbox = $Punchbox
onready var kickbox = $Kickbox
onready var hurtbox = $Hurtbox

### ready #####################################################################


func _ready():
  Notif.notif("ready")

  patrol_points.append(get_global_position())

  print("attack_slots", attack_slots())

func get_move_vector():
  if is_player:
    return Trols.move_dir()
  elif move_in_dir:
    return move_in_dir.normalized()
  else:
    return Vector2()

func approach_target(position = null):
  if position:
    move_in_dir = get_global_position().direction_to(position).normalized()
  elif target:
    # if target is valid
    move_in_dir = get_global_position().direction_to(target.get_global_position()).normalized()
  else:
    print("no target to approach!")

### process #####################################################################


func flip_transform(area):
  match facing:
    face_dir.LEFT:
      area.transform.origin.x = -abs(area.transform.origin.x)
    face_dir.RIGHT:
      area.transform.origin.x = abs(area.transform.origin.x)


func update_facing(dir: int):
  facing = dir
  animated_sprite.flip_h = dir == face_dir.LEFT
  flip_transform(animated_sprite)
  flip_transform(facing_detector)
  flip_transform(punchbox)
  flip_transform(kickbox)
  flip_transform(hurtbox)


func _process(_delta):
  var move_vector: Vector2 = get_move_vector()
  var old_facing = facing
  var new_facing = facing
  if move_vector.x > 0:
    new_facing = face_dir.RIGHT
  elif move_vector.x < 0:
    new_facing = face_dir.LEFT

  if old_facing != new_facing:
    update_facing(new_facing)

  if stunned:
    animated_sprite.animation = "stunned"
  elif knocked_back:
    animated_sprite.animation = "knocked_back"
  elif kicking:
    animated_sprite.animation = "kick"
  elif punching:
    animated_sprite.animation = "punch"
  elif move_vector.length() > 0:
    animated_sprite.animation = "walk"
  else:
    animated_sprite.animation = "idle"


### physics_process #####################################################################

const DECELERATION = 100


func _physics_process(delta):
  var move_vector: Vector2 = get_move_vector()

  if punching or kicking or stunned or knocked_back:
    move_vector = Vector2()

  # note, constant velocity here
  velocity = move_vector * speed

  velocity = velocity.move_toward(Vector2(), DECELERATION * delta)

  velocity = move_and_slide(velocity)


### unhandled_input #####################################################################


func _unhandled_input(event):
  if is_player and Trols.is_attack(event):
    attack()


### attacking #####################################################################

var stunned = false
var knocked_back = false

var punching = false
var punch_windup = 0.1
var punch_cooldown = 0.2

var kicking = false
var kick_windup = 0.1
var kick_cooldown = 0.3

var in_punchbox = []
var in_kickbox = []
var in_detectbox = []

onready var combo_timer = $ComboTimer
export(float) var combo_timeout := 1
var combo_count = 0

signal punch
signal kick


func can_attack():
  return not punching and not kicking and not stunned and not knocked_back


var attack_queue = 0


func attack():
  if can_attack():
    if combo_count >= 2:
      reset_combo()
      kick()
    else:
      combo_count += 1
      punch()

      # restart the combo timer.
      combo_timer.start(combo_timeout)
  else:
    if punching or kicking:
      if attack_queue < 1:
        attack_queue += 1
      else:
        print("refusing to queue more attacks")
    elif stunned or knocked_back:
      print("dead input, attack input while stunned/knocked_back")
    else:
      print("some other dead input on attack")


func _on_ComboTimer_timeout():
  reset_combo()


# Resets the combo and the queue
func reset_combo():
  combo_count = 0
  attack_queue = 0


func punch():
  punching = true
  yield(get_tree().create_timer(punch_windup), "timeout")

  if not stunned and not knocked_back:
    emit_signal("punch", self)  # maybe just for metrics/ui?

    for ch in in_punchbox:
      print("punching: ", ch)
      if ch.has_method("take_punch"):
        ch.take_punch(self)

  yield(get_tree().create_timer(punch_cooldown), "timeout")
  punching = false
  if attack_queue > 0:
    attack_queue -= 1
    attack()


func kick():
  kicking = true
  yield(get_tree().create_timer(kick_windup), "timeout")

  if not stunned and not knocked_back:
    emit_signal("kick", self)

    for ch in in_kickbox:
      print("kicking: ", ch)
      if ch.has_method("take_kick"):
        ch.take_kick(self)

  yield(get_tree().create_timer(kick_cooldown), "timeout")
  kicking = false


### defending? #####################################################################

var stunned_time = 0.3
var knocked_back_time = 0.5
export(int) var PUNCH_FORCE = 20
export(int) var KICK_FORCE = 100


func take_punch(attacker):
  reset_combo()
  face_attacker(attacker)
  stunned = true
  # TODO consider only knocking back on punch if they are close
  # i.e. don't punch them out of punch-range
  apply_attack(attacker, attacker.PUNCH_FORCE)
  yield(get_tree().create_timer(stunned_time), "timeout")
  stunned = false


func take_kick(attacker):
  reset_combo()
  face_attacker(attacker)
  knocked_back = true
  apply_attack(attacker, attacker.KICK_FORCE)
  yield(get_tree().create_timer(knocked_back_time), "timeout")
  knocked_back = false


func apply_attack(attacker, attack_force):
  var force = Vector2(1, 0) * attack_force
  if attacker.position.x > get_global_position().x:
    # attacker is on the right, so x should be negative
    force = force * -1
  velocity += force


func face_attacker(attacker):
  var new_facing = facing
  if attacker.position.x > get_global_position().x:
    new_facing = face_dir.RIGHT
  elif attacker.position.x < get_global_position().x:
    new_facing = face_dir.LEFT
  update_facing(new_facing)


### hitbox signals ##########################################################


func _on_Punchbox_area_entered(area):
  if area.is_in_group("hurtboxes") and area != hurtbox:
    in_punchbox.append(area.get_parent())

func _on_Punchbox_area_exited(area):
  in_punchbox.erase(area.get_parent())

func _on_Kickbox_area_entered(area):
  if area.is_in_group("hurtboxes") and area != hurtbox:
    in_kickbox.append(area.get_parent())

func _on_Kickbox_area_exited(area):
  in_kickbox.erase(area.get_parent())

func _on_Detectbox_area_entered(area:Area2D):
  # TODO perhaps hurtboxes isn't the right group for this?
  # likely fine for now
  if area.is_in_group("hurtboxes") and area != hurtbox:
    in_detectbox.append(area.get_parent())

func _on_Detectbox_area_exited(area:Area2D):
  in_detectbox.erase(area.get_parent())

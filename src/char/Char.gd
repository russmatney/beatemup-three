extends KinematicBody2D

var char_name

var velocity = Vector2()
var speed = 200

# direction the AI wants to move in
var ai_move_in_dir = Vector2()
var patrol_points = []

enum face_dir { LEFT, RIGHT }
export(face_dir) var facing = face_dir.RIGHT

export(bool) var is_player = false

var current_health
export(int) var total_health = 5
var lives = 2

# some target this agent wants to attack
# assigned in behaviors/DetectsPlayer
var target
var targetted_by = []
onready var attack_slot_a = $AttackSlotA
onready var attack_slot_b = $AttackSlotB


func attack_slots():
	return [attack_slot_a, attack_slot_b]


onready var animated_sprite = $AnimatedSprite

onready var punchbox = $Punchbox
onready var kickbox = $Kickbox
onready var hurtbox = $Hurtbox

onready var sound_punch = $SoundPunch
onready var sound_punch_2 = $SoundPunch2
onready var sound_kick = $SoundKick
onready var sound_death = $SoundDeath
onready var sound_combo = $SoundCombo
onready var sound_combo_2 = $SoundCombo2
onready var sound_combo_lost = $SoundComboLost

signal punch
signal kick
signal death
signal died
signal combo
signal combo_lost

onready var machine = $Machine
onready var state_label = $StateLabel

### ready #####################################################################


func _ready():
	patrol_points.append(get_global_position())

	current_health = total_health
	if is_player:
		HUD.set_player_status(self)

	machine.connect("transitioned", self, "_on_state_transition")

	machine.should_log = not is_in_group("player")

	connect("punch", self, "_on_punch_landed")
	connect("kick", self, "_on_kick_landed")
	connect("death", self, "_on_death")
	connect("combo", self, "_on_combo")
	connect("combo_lost", self, "_on_combo_lost")


func _on_state_transition(new_state):
	if state_label:
		state_label.bbcode_text = "[center]" + new_state + "[/center]"


func assign_target(new_target):
	# remove this char from existing_target.targetted_by
	var existing_target = target
	if existing_target and is_instance_valid(existing_target):
		# maybe need some other way to deal with this
		existing_target.targetted_by.erase(self)

	target_closest_slot = null

	target = new_target
	new_target.targetted_by.append(self)


var target_closest_slot


func direction_to_target(position = null):
	if position:
		return get_global_position().direction_to(position).normalized()
	elif target_closest_slot and is_instance_valid(target_closest_slot):
		return get_global_position().direction_to(target_closest_slot.get_global_position()).normalized()
	elif target and is_instance_valid(target):
		if not target_closest_slot:
			var slots = target.attack_slots()
			if slots.size() > 0:
				# TODO calc this
				target_closest_slot = slots[0]
			else:
				return get_global_position().direction_to(target.get_global_position()).normalized()


### facing #####################################################################


func flip_transform(area):
	match facing:
		face_dir.LEFT:
			area.transform.origin.x = -abs(area.transform.origin.x)
		face_dir.RIGHT:
			area.transform.origin.x = abs(area.transform.origin.x)


func update_facing(dir: int):
	facing = dir
	animated_sprite.flip_h = facing == face_dir.LEFT
	flip_transform(animated_sprite)
	flip_transform(punchbox)
	flip_transform(kickbox)
	flip_transform(hurtbox)


func face(move_dir: Vector2):
	var old_facing = facing
	var new_facing = facing
	if move_dir.x > 0:
		new_facing = face_dir.RIGHT
	elif move_dir.x < 0:
		new_facing = face_dir.LEFT

	if old_facing != new_facing:
		update_facing(new_facing)


### walking #####################################################################

const DECELERATION = 100


func walk(move_dir: Vector2, delta: float):
	# note, constant velocity here
	velocity = move_dir * speed

	# decelerate
	velocity = velocity.move_toward(Vector2(), DECELERATION * delta)
	velocity = move_and_slide(velocity)


### sound #################################################################


func _on_punch_landed():
	if is_player:
		match randi() % 2:
			0:
				sound_punch.play()
			1:
				sound_punch_2.play()


func _on_kick_landed():
	if is_player:
		sound_kick.play()


func _on_death():
	if is_player:
		sound_death.play()


func _on_combo():
	if is_player:
		match randi() % 2:
			0:
				sound_combo.play()
			1:
				sound_combo_2.play()


func _on_combo_lost():
	if is_player:
		sound_combo_lost.play()


### attacking #####################################################################

var punching = false
var punch_windup = 0.1
var punch_cooldown = 0.2

var kicking = false
var kick_windup = 0.1
var kick_cooldown = 0.3

var in_punchbox = []
var in_kickbox = []
var in_detectbox = []

# combo_count determines if we should punch or kick
onready var combo_timer = $ComboTimer
export(float) var combo_timeout := 1
var combo_count = 0

# score_combo_count is aesthetic, for display and score
onready var score_combo_timer = $ScoreComboTimer
export(float) var score_combo_timeout := 3
var score_combo_count = 0

var attack_queue = 0

signal attack_complete


func attack():
	if combo_count >= 2:
		reset_combo()
		kick()
	else:
		combo_count += 1
		punch()
		combo_timer.start(combo_timeout)


func _on_ComboTimer_timeout():
	reset_combo()


func _on_ScoreComboTimer_timeout():
	score_combo_count = 0
	if is_player:
		emit_signal("combo_lost")
		HUD.set_player_status(self)


# Resets the combo and the queue
func reset_combo():
	combo_count = 0
	attack_queue = 0


func can_take_hit(ch):
	return (
		ch.machine.state.name
		in [
			"Idle",
			"Walk",
			"Approach",
			"DukesUp",
			"Attack", # TODO some attacks could be countered/interrupted?
		]
	)

func can_attack():
	return machine.state.name == "Attack"

func punch():
	punching = true
	yield(get_tree().create_timer(punch_windup), "timeout")

	if can_attack():
		var landed = false
		for ch in in_punchbox:
			if ch.has_method("take_punch") and can_take_hit(ch):
				ch.take_punch(self)
				landed = true

		if landed:
			emit_signal("punch")

	yield(get_tree().create_timer(punch_cooldown), "timeout")
	punching = false
	emit_signal("attack_complete")
	if attack_queue > 0:
		attack_queue -= 1
		attack()


func kick():
	kicking = true
	yield(get_tree().create_timer(kick_windup), "timeout")

	if can_attack():
		var landed = false
		for ch in in_kickbox:
			# TODO only punch targetted groups?
			if ch.has_method("take_kick") and can_take_hit(ch):
				ch.take_kick(self)
				landed = true

		if landed:
			emit_signal("kick")

	yield(get_tree().create_timer(kick_cooldown), "timeout")
	emit_signal("attack_complete")
	kicking = false


### defending? #####################################################################

var stunned = false
var knocked_back = false

var stunned_time = 0.3
var knocked_back_time = 0.5
export(int) var PUNCH_FORCE = 30
export(int) var KICK_FORCE = 300

export(int) var punch_damage = 2
export(int) var kick_damage = 3


func take_punch(attacker):
	HUD.notif("Punch!!")
	reset_combo()
	face_attacker(attacker)
	stunned = true
	# TODO consider only knocking back on punch if they are close
	# i.e. don't punch them out of punch-range
	apply_attack(attacker, stunned_time, attacker.PUNCH_FORCE, attacker.punch_damage)
	yield(get_tree().create_timer(stunned_time), "timeout")
	stunned = false


func take_kick(attacker):
	HUD.notif("Kick!!")
	reset_combo()
	face_attacker(attacker)
	knocked_back = true
	apply_attack(attacker, knocked_back_time, attacker.KICK_FORCE, attacker.kick_damage)
	yield(get_tree().create_timer(knocked_back_time), "timeout")
	knocked_back = false


func apply_attack(attacker, time, attack_force, attack_damage):
	current_health -= attack_damage

	if attacker.is_player:
		attacker.score_combo_count += 1
		emit_signal("combo")
		attacker.score_combo_timer.start(attacker.score_combo_timeout)
		HUD.notif("Combo:" + str(attacker.score_combo_count))
		HUD.set_enemy_status(self)
		HUD.set_player_status(attacker)
	elif is_player:
		emit_signal("combo_lost")
		score_combo_count = 0
		HUD.set_player_status(self)
		HUD.set_enemy_status(attacker)

	var force = Vector2(1, 0) * attack_force
	if attacker.get_global_position().x > get_global_position().x:
		# attacker is on the right, so x should be negative
		force = force * -1

	if current_health <= 0:
		# start_dying()
		machine.transit("Dying", {"force": force, "time": time})
	else:
		# some states could just ignore entering knockback/dying?
		machine.transit("KnockedBack", {"force": force, "time": time})


func face_attacker(attacker):
	var new_facing = facing
	if attacker.get_global_position().x > get_global_position().x:
		new_facing = face_dir.RIGHT
	elif attacker.get_global_position().x < get_global_position().x:
		new_facing = face_dir.LEFT
	update_facing(new_facing)


# how long dead before rebirth
export(float) var dead_time = 3.0


func remove_dead_player():
	# TODO move to 'removed'
	emit_signal("died")
	for ch in targetted_by:
		if is_instance_valid(ch):
			ch.target = null
	targetted_by.erase(self)
	queue_free()


func remove_char():
	emit_signal("died")
	for ch in targetted_by:
		if is_instance_valid(ch):
			ch.target = null
	targetted_by.erase(self)
	queue_free()


### hitbox signals ##########################################################


func _on_Punchbox_area_entered(area):
	if area.is_in_group("hurtboxes") and area != hurtbox:
		var ch = area.get_parent()
		if is_player:
			in_punchbox.append(ch)
		elif ch.is_in_group("player"):
			in_punchbox.append(ch)


func _on_Punchbox_area_exited(area):
	in_punchbox.erase(area.get_parent())


func _on_Kickbox_area_entered(area):
	if area.is_in_group("hurtboxes") and area != hurtbox:
		var ch = area.get_parent()
		if is_player:
			in_kickbox.append(ch)
		elif ch.is_in_group("player"):
			in_kickbox.append(ch)


func _on_Kickbox_area_exited(area):
	in_kickbox.erase(area.get_parent())


func _on_Detectbox_area_entered(area: Area2D):
	# TODO perhaps hurtboxes isn't the right group for this?
	# likely fine for now
	if area.is_in_group("hurtboxes") and area != hurtbox:
		in_detectbox.append(area.get_parent())


func _on_Detectbox_area_exited(area: Area2D):
	in_detectbox.erase(area.get_parent())

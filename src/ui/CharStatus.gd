extends Control

var char_name_label
var lives_label
var score_label
var combo_label

var character

var health_bar
var health_bar_initial_rect

### ready #####################################################################


func _ready():
	char_name_label = find_node("CharName")
	lives_label = find_node("Lives")
	# score_label = find_node("Score")
	combo_label = find_node("Combo")

	health_bar = find_node("HealthBar")
	health_bar_initial_rect = health_bar.rect_size

	hide()


### show/hide labels #####################################################################


func hide():
	char_name_label.visible = false
	health_bar.visible = false
	lives_label.visible = false
	lives_label.get_parent().visible = false
	# score_label.visible = false
	combo_label.visible = false


func show_all():
	char_name_label.visible = true
	health_bar.visible = true
	lives_label.visible = true
	lives_label.get_parent().visible = true
	# score_label.visible = true
	combo_label.visible = true


func show_basic():
	char_name_label.visible = true
	health_bar.visible = true


### set char #####################################################################


func set_char(ch):
	character = ch
	set_char_label(ch.char_name if ch.char_name else ch.name)
	set_health(ch.current_health, ch.total_health)
	show_basic()
	if ch.is_player:
		set_lives(ch.lives)
		# set_score(ch.score)
		set_combos(ch.score_combo_count)
		show_all()


func clear_char():
	hide()
	character = null


### update labels #####################################################################


func set_char_label(name):
	char_name_label.bbcode_text = name


func set_health(current: int, total: int):
	# var bar_size_x = int(health_bar_initial_rect.x * (total / 10.0))
	# var bar_size_x = int(health_bar_initial_rect.x * (total / 10.0))
	# health_bar.rect_size.x = bar_size_x
	# health_bar.rect_min_size.x = bar_size_x
	# health_bar_initial_rect.x = bar_size_x
	# health_bar.set_size(health_bar_initial_rect)

	health_bar.max_value = total * health_bar_initial_rect.x
	health_bar.value = current * health_bar_initial_rect.x


func set_lives(current: int):
	# lol zero padding
	lives_label.bbcode_text = "[center]0" + str(current) + "[/center]"


func set_score(_current: int):
	pass


# score_label.bbcode_text = "[right]Score: " + str(current) + "[/right]"


func set_combos(current: int):
	combo_label.bbcode_text = "[center]" + str(current) + "[/center]"

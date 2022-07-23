# https://github.com/benbishopnz/godot-credits
extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	["A game by Russell Matney"],
	["Created in 6 days for Weekly Jam #261", "https://itch.io/jam/weekly-game-jam-261"],
	[
		"Tools used",
		"",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with Aseprite",
		"https://www.aseprite.org/",
	],
	[
		"Music",
		"",
		"Bleeping Demo",
		"Canon In D For 8 Bit Synths",
		"SCP-x3x (I am Not OK)",
		"Kevin MacLeod (incompetech.com)",
		"Licensed under Creative Commons: By Attribution 4.0 License",
		"http://creativecommons.org/licenses/by/4.0/",
	],
	[
		"Sounds",
	],
	[
		"Boom Bang",
		"",
		"Bjørn Molstad / BareForm",
		"Licensed under Creative Commons: By Attribution 3.0 License",
		"https://creativecommons.org/licenses/by/3.0/",
	],
	[
		"Growler Music",
		"",
		"Gong hit, Cowbell",
		"Licensed under Creative Commons: By Attribution 3.0 License",
		"https://creativecommons.org/licenses/by/3.0/",
	],
	[
		"DWSD - Dan Wray",
		"",
		"jhd_cym_1, jhd_hat_1, jhd_hat_2, jhd_bd_10",
		"https://freesound.org/people/DWSD/sounds/191613/",
		"Licensed under Creative Commons: By Attribution 3.0 License",
		"https://creativecommons.org/licenses/by/3.0/"
	],
	[
		"Art",
		"",
		"Kenney Roguelike Modern City",
		"Licensed under Creative Commons: By Attribution 1.0 License",
		"https://creativecommons.org/licenses/by/1.0/",
	],
	[
		"Fonts",
		"",
		"at01",
		"https://itch.io/queue/c/733269/godot-pixel-fonts?game_id=707314",
		"Licensed under Creative Commons: By Attribution 1.0 License",
		"https://creativecommons.org/licenses/by/1.0/",
	],
	["Special thanks", "", "Duaa", "Greg", "Cameron", "The World"],
]

export(bool) var should_run = false


func roll():
	should_run = true


func _process(delta):
	if should_run:
		var scroll_speed = base_speed * delta

		if section_next:
			section_timer += delta * speed_up_multiplier if speed_up else delta
			if section_timer >= section_time:
				section_timer -= section_time

				if credits.size() > 0:
					started = true
					section = credits.pop_front()
					curr_line = 0
					add_line()

		else:
			line_timer += delta * speed_up_multiplier if speed_up else delta
			if line_timer >= line_time:
				line_timer -= line_time
				add_line()

		if speed_up:
			scroll_speed *= speed_up_multiplier

		if lines.size() > 0:
			for l in lines:
				l.rect_position.y -= scroll_speed
				if l.rect_position.y < -l.get_line_height():
					lines.erase(l)
					l.queue_free()
		elif started:
			finish()


func finish():
	if not finished:
		finished = true
	# NOTE: This is called when the credits finish
	# - Hook up your code to return to the relevant scene here, eg...
	#get_tree().change_scene("res://scenes/MainMenu.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	$CreditsContainer.add_child(new_line)

	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if should_run:
		if event.is_action_pressed("ui_cancel"):
			finish()
		if event.is_action_pressed("ui_down") and !event.is_echo():
			speed_up = true
		if event.is_action_released("ui_down") and !event.is_echo():
			speed_up = false

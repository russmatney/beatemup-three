extends State

## enter ###########################################################


func enter(arg = {}):
	# TODO flicker visibility? fade out?

	var force: Vector2 = arg.get("force")
	if force:
		owner.velocity = force
		var time = arg.get("time", 1.0)
		yield(get_tree().create_timer(time), "timeout")

	HUD.notif("Death comes to us all.")
	if owner.is_player:
		HUD.banner(str(owner.lives) + " lives remaining!")
	owner.emit_signal("death")

	owner.animated_sprite.animation = "dying"

	yield(get_tree().create_timer(owner.dead_time), "timeout")

	transit("Dead")


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################


func physics_process(_delta):
	pass

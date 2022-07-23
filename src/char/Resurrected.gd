extends State

## enter ###########################################################


func enter(_arg = {}):
	HUD.notif("Resurrection!")
	owner.current_health = owner.total_health
	HUD.set_player_status(owner)

	yield(get_tree().create_timer(2.0), "timeout")

	transit("Idle")


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################


func physics_process(_delta):
	pass

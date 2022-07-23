extends State


func enter(_arg = {}):
	owner.animated_sprite.animation = "walk"


func process(_delta: float):
	owner.face(Trolley.move_dir())


func physics_process(delta: float):
	owner.walk(Trolley.move_dir(), delta)

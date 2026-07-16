extends CharacterBody3D

enum States {attack, idle, chase, die}

var state = States.idle
var hp = 15
var speed = 2
var accel = 10
var gravity = 9.8
var target = null
@export var navigation_agent_3d: NavigationAgent3D

func _physics_process(_delta: float) -> void:
	if state == States.idle:
		print("idel")
		velocity = Vector3.ZERO
	elif state == States.chase:
		print("chase")
		velocity = Vector3.ZERO
	elif state == States.attack:
		print("attack")
		velocity = Vector3.ZERO
	elif state == States.die:
		print("die")
		velocity = Vector3.ZERO
		

func _on_chase_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		target = body
		state = States.chase

func _on_chase_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		target = null
		state = States.idle

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		state = States.attack

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		state = States.chase

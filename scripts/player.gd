extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 5.0
var sensivity = 0.003
var oncooldown = false

var gold = 0
var hp = 50
var MaxHp = 50
var damage = 10
var target = []

@onready var hp_bar: TextureProgressBar = $HUD/HpBar
@onready var gold_label: Label = $HUD/GoldLabel
@onready var camera_3d: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooldown: Timer = $cooldown

func player():
	pass

func attack():
	if Input.is_action_just_pressed("attack") and oncooldown == false:
		animation_player.play("swing")
		oncooldown = true
		cooldown.start()

func deal_damage():
	for enimes in target:
		enimes.hp -= damage
	
func _ready() -> void:
	hp_bar.max_value = 50
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensivity)
		camera_3d.rotate_x(-event.relative.y * sensivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func update_HUD():
	hp_bar.value = hp
	gold_label.text = str(gold)

func _process(_delta: float) -> void:
	update_HUD()
	attack()
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_cooldown_timeout() -> void:
	oncooldown = false


func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.append(body)


func _on_attack_zone_body_exited(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.erase(body)

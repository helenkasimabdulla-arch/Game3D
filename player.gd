extends CharacterBody3D

# --- Bevægelse ---
@export var walk_speed: float = 4.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003

# --- Stamina ---
@export var max_stamina: float = 100.0
@export var stamina_drain: float = 25.0
@export var stamina_regen: float = 10.0
@export var regen_delay: float = 1.0
@export var min_stamina_to_sprint: float = 15.0

var stamina: float = max_stamina
var regen_timer: float = 0.0
var exhausted: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var stamina_bar: ProgressBar = $CanvasLayer/ProgressBar


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var wants_to_sprint := Input.is_action_pressed("sprint") and input_dir != Vector2.ZERO
	var can_sprint := not exhausted and stamina > 0.0
	var is_sprinting := wants_to_sprint and can_sprint

	if is_sprinting:
		stamina -= stamina_drain * delta
		regen_timer = regen_delay
		if stamina <= 0.0:
			stamina = 0.0
			exhausted = true
	else:
		if regen_timer > 0.0:
			regen_timer -= delta
		else:
			stamina = min(stamina + stamina_regen * delta, max_stamina)
		if exhausted and stamina >= min_stamina_to_sprint:
			exhausted = false

	var speed := sprint_speed if is_sprinting else walk_speed

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	stamina_bar.value = stamina

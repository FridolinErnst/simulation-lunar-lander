#TODO make the code nicer with the comment and make it so that
# tilting does not affect camera and rotating only affects camera
# when default_position in camera_rig script is true

extends CharacterBody3D
@onready var propeller_rotation: AnimationPlayer = $LunarLanderCopter/PropellerRotation

# UI
@onready var fuel_label: Label = $"../UI/FuelLabel"
@onready var velocity_label: Label = $"../UI/VelocityLabel"

@onready var explosion_particle_system: Node3D = $ExplosionParticleSystem
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var congrats_label: Label = $"../UI/CenterContainer/CongratsLabel"
@onready var winsound: AudioStreamPlayer3D = $Winsound


# --- FUEL SYSTEM ---
@export var fuel: float = OptionsMenuVars.fuel     # Current fuel
@export var fuel_burn_rate: float = 10.0  # Fuel used per second when applying thrust
var fuel_used := false
var paused : bool = true

# Helicopter physical properties
var mass: float = 1000.0
var acceleration: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO

# Constants
const ROTATION_SPEED: float = 1.5
#const OptionsMenuVars.thrust: float = 8000.0

# Tilt settings
const MAX_TILT_DEG: float = 15.0   # maximum tilt angle
const TILT_SPEED: float = 5.0      # how fast it interpolates

var tilt_target: Vector2 = Vector2.ZERO   # x = roll (left/right), y = pitch (forward/back)
var tilt_current: Vector2 = Vector2.ZERO


#Landing

@onready var front_wheel: Area3D = $FrontWheel
@onready var back_wheels: Area3D = $BackWheels

var front_on_pad: bool = false
var back_on_pad: bool = false


func _ready():
	set_physics_process(false)
	front_wheel.area_entered.connect(_on_front_wheel_entered)
	front_wheel.area_exited.connect(_on_front_wheel_exited)
	back_wheels.area_entered.connect(_on_back_wheels_entered)
	back_wheels.area_exited.connect(_on_back_wheels_exited)
	OptionsMenuVars.connect("options_applied", _on_options_applied)
	OptionsMenuVars.connect("game_paused", _on_game_paused)

func _physics_process(delta: float) -> void:
	force = Vector3.ZERO
	fuel_used = false

	# --- OptionsMenuVars.gravity ---
	force.y += mass * OptionsMenuVars.gravity

	# --- INPUT: VERTICAL (Arrow keys) ---
	if fuel > 0:
		if Input.is_action_pressed("ui_up"):     # ascend
			force.y += OptionsMenuVars.thrust
			fuel_used = true

		if Input.is_action_pressed("ui_down"):   # descend
			force.y -= OptionsMenuVars.thrust
			fuel_used = true

	# --- INPUT: HORIZONTAL (WASD) ---

	"""
	here some shorter input with less ifs:

			# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "forward", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)


		move_and_slide()
	"""


	var move_dir = Vector3.ZERO
	tilt_target = Vector2.ZERO

	if fuel > 0:
		if Input.is_action_pressed("move_forward"):  # W
			move_dir -= global_transform.basis.z
			tilt_target.y = -MAX_TILT_DEG # pitch forward
			fuel_used = true

		if Input.is_action_pressed("move_backward"): # S
			move_dir += global_transform.basis.z
			tilt_target.y = MAX_TILT_DEG  # pitch backward
			fuel_used = true

		if Input.is_action_pressed("move_left"):     # A
			move_dir -= global_transform.basis.x
			tilt_target.x = -MAX_TILT_DEG # roll left
			fuel_used = true

		if Input.is_action_pressed("move_right"):    # D
			move_dir += global_transform.basis.x
			tilt_target.x = MAX_TILT_DEG  # roll right
			fuel_used = true

		if move_dir != Vector3.ZERO:
			force += move_dir.normalized() * OptionsMenuVars.thrust
			fuel_used = true

		# --- INPUT: ROTATION (Arrow Left/Right) ---
		if Input.is_action_pressed("ui_left"):
			rotate_y(ROTATION_SPEED * delta)
		if Input.is_action_pressed("ui_right"):
			rotate_y(-ROTATION_SPEED * delta)

	# --- APPLY TILT (interpolation) ---
	tilt_current = tilt_current.lerp(tilt_target, delta * TILT_SPEED)
	rotation_degrees.x = tilt_current.y   # pitch
	rotation_degrees.z = -tilt_current.x  # roll (invert so A tilts left)

	# --- DYNAMICS ---
	acceleration = force / mass
	velocity += acceleration * delta

	# --- MOVE ---
	global_position += velocity * delta

	if fuel_used:
		audio_stream_player_3d.set_pitch_scale(1.05)
		propeller_rotation.set_speed_scale(0.5)

	if !fuel_used and fuel > 0:
		audio_stream_player_3d.set_pitch_scale(0.95)
		propeller_rotation.set_speed_scale(1.5)
	if fuel <1:
		audio_stream_player_3d.stop()


func _process(delta: float) -> void:
# UI Updates
	# Reduce fuel
	if fuel_used:
		fuel = max(fuel - fuel_burn_rate * delta, 0)
	if fuel_label:
		fuel_label.text = "Fuel: %d" % int(fuel)
	if velocity_label:
		var vx = velocity.x
		var vy = velocity.y
		var vz = velocity.z
		var speed = velocity.length()
		velocity_label.text = "Velocity: X=%.2f / Y=%.2f / Z=%.2f / Speed=%.2f" % [vx, vy, vz, speed]




func check_landing() -> void:
	print("checking landing")
	if front_on_pad and back_on_pad:
		print("all wheels connected")
		if abs(velocity.y) <= OptionsMenuVars.landing_speed:
			print("✅ Successful landing!")
			velocity = Vector3.ZERO
			congrats_label.visible = true
			set_physics_process(false)
			audio_stream_player_3d.stop()
			winsound.play(0.7)
			await get_tree().create_timer(2.0).timeout
			congrats_label.visible = false
			winsound.stop()
			Global.game_controller.reload_3d_scene()
		else:
			print("💥 Crash landing!")
			crashed()


func crashed() -> void:
	set_physics_process(false)
	explosion_particle_system.explode()
	print("crashed on ground")
	await get_tree().create_timer(2.0).timeout
	audio_stream_player_3d.stop()
	Global.game_controller.reload_3d_scene()


func _on_front_wheel_entered(area: Area3D) -> void:
	if area.is_in_group("landing_pad"):
		front_on_pad = true
		print("front wheel connected")
		check_landing()

func _on_front_wheel_exited(area: Area3D) -> void:
	if area.is_in_group("landing_pad"):
		front_on_pad = false
		print("front wheel diconnected")


func _on_back_wheels_entered(area: Area3D) -> void:
	if area.is_in_group("landing_pad"):
		back_on_pad = true
		check_landing()
		print("back wheels connected")


func _on_back_wheels_exited(area: Area3D) -> void:
	if area.is_in_group("landing_pad"):
		back_on_pad = false
		print("back wheels disconnected")


func _on_options_applied() -> void:
	fuel = OptionsMenuVars.fuel

func _on_game_paused() -> void:
	set_physics_process(paused)
	paused = !paused
	if !paused:
		audio_stream_player_3d.play(0.6)
	else:
		audio_stream_player_3d.stop()

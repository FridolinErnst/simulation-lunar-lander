extends Node3D  # Script on CameraMount

@export var sens_horizontal := 0.5
@export var sens_vertical := 0.5
@export var reset_speed := 5.0
@export var close_pos_eps := 0.01
@export var close_yaw_eps_deg := 0.5

@onready var lunar_lander_copter: Node3D = $"../../LunarLanderCopter"

var default_position := true
var resetting := false
var parent : Node3D
var default_mount_transform : Transform3D
var default_yaw_offset : float   # (parent_yaw - lander_yaw) at game start
var paused : bool = true

func _ready():
	parent = get_parent()
	# Save the mount's starting LOCAL transform (height/offset/pitch)
	default_mount_transform = transform
	OptionsMenuVars.connect("game_paused", _on_game_paused)

	# Save yaw offset between the parent yaw container and the lander
	# (works even if Player root is rotated later)
	default_yaw_offset = parent.global_rotation.y - lunar_lander_copter.global_rotation.y
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_game_paused() -> void:
	paused = !paused
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if !paused:
		if event is InputEventMouseMotion:
			default_position = false
			resetting = false
			# Rotate parent (Player yaw)
			parent.rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))

			# Rotate self (CameraMount pitch)
			rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
			rotation_degrees.x = clamp(rotation_degrees.x, -89.0, 89.0)

		# Example: Space (ui_select) to reset
		if event.is_action_pressed("ui_select"):
			reset_position()


func reset_position():
	default_position = true
	resetting = true


func _process(delta):
	if not resetting:
		return

	# --- 1) Lerp CameraMount back to its start transform ---
	transform.basis = transform.basis.slerp(
		default_mount_transform.basis, delta * reset_speed
	)
	transform.origin = transform.origin.lerp(
		default_mount_transform.origin, delta * reset_speed
	)

	# --- 2) Rotate parent yaw so camera is behind the *current* lander yaw ---
	var target_yaw := lunar_lander_copter.global_rotation.y + default_yaw_offset
	parent.global_rotation.y = lerp_angle(parent.global_rotation.y, target_yaw, delta * reset_speed)

	# --- 3) Stop when close enough ---
	var pos_close := transform.origin.distance_to(default_mount_transform.origin) < close_pos_eps
	var rot_close_mount := transform.basis.is_equal_approx(default_mount_transform.basis)
	var yaw_close := absf(wrapf(parent.global_rotation.y - target_yaw, -PI, PI)) < deg_to_rad(close_yaw_eps_deg)

	if pos_close and rot_close_mount and yaw_close:
		transform = default_mount_transform
		parent.global_rotation.y = target_yaw
		resetting = false

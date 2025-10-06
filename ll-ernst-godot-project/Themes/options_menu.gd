extends Control


func _ready() -> void:
	OptionsMenuVars.connect("level_changed", _on_level_changed)
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SurfaceGravityValue.value = OptionsMenuVars.gravity
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SafeLandingSpeedValue.value = OptionsMenuVars.landing_speed
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/FuelTankValue.value = OptionsMenuVars.fuel
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/ThrustValue.value = OptionsMenuVars.thrust

func _exit_tree() -> void:
	if OptionsMenuVars.is_connected("level_changed", _on_level_changed):
		OptionsMenuVars.disconnect("level_changed", _on_level_changed)

func _on_apply_button_pressed() -> void:
	print("apply button pressed")
	OptionsMenuVars.gravity = $PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SurfaceGravityValue.value
	OptionsMenuVars.landing_speed = $PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SafeLandingSpeedValue.value
	OptionsMenuVars.fuel = $PanelContainer/VBoxContainer/HBoxContainer/GridContainer/FuelTankValue.value
	OptionsMenuVars.thrust = $PanelContainer/VBoxContainer/HBoxContainer/GridContainer/ThrustValue.value
	OptionsMenuVars.emit_signal("options_applied")


func _on_level_changed(level_name : String) -> void:
		# If you want different defaults per scene:
	print("inisde level changed, level name:", level_name)

	match level_name:
		"Level1":
			OptionsMenuVars.gravity = -1.625
			OptionsMenuVars.landing_speed = 20.0
			OptionsMenuVars.fuel = 100.0
			OptionsMenuVars.thrust = 15000.0
		"Level2":
			OptionsMenuVars.gravity = -3.711
			OptionsMenuVars.landing_speed = 25.0
			OptionsMenuVars.fuel = 250.0
			OptionsMenuVars.thrust = 12000.0
		"Level3":
			OptionsMenuVars.gravity = -3.711
			OptionsMenuVars.landing_speed = 250.0
			OptionsMenuVars.fuel = 80.0
			OptionsMenuVars.thrust = 37000.0
		_:
			pass

	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SurfaceGravityValue.value = OptionsMenuVars.gravity
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/SafeLandingSpeedValue.value = OptionsMenuVars.landing_speed
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/FuelTankValue.value = OptionsMenuVars.fuel
	$PanelContainer/VBoxContainer/HBoxContainer/GridContainer/ThrustValue.value = OptionsMenuVars.thrust
	OptionsMenuVars.emit_signal("options_applied")

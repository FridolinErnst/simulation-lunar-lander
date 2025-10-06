extends CanvasLayer


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_menu()

func toggle_menu():
	visible = !visible
	OptionsMenuVars.emit_signal("game_paused")

"""
	if visible:
		get_tree().paused = true   # pause the game
	else:
		get_tree().paused = false  # unpause the game
"""

func _on_level_1_pressed() -> void:
	Global.game_controller.change_3d_scene("res://Level1.tscn", true)
	OptionsMenuVars.emit_signal("level_changed", "Level1")



func _on_level_2_pressed() -> void:
	Global.game_controller.change_3d_scene("res://Level2.tscn", true)
	OptionsMenuVars.emit_signal("level_changed", "Level2")


func _on_level_3_pressed() -> void:
	Global.game_controller.change_3d_scene("res://Level3.tscn", true)
	OptionsMenuVars.emit_signal("level_changed", "Level3")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_support_dev_pressed() -> void:
	var btn = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/Levels/PanelContainer/VBoxContainer/SupportDev
	var original_text = btn.text

	btn.text = "Haha Thanks!"
	await get_tree().create_timer(2.0).timeout
	btn.text = original_text

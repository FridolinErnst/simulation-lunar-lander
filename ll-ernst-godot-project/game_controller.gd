extends Node
class_name GameController

@export var world_3d: Node3D
@export var world_2d: Node2D
@export var gui: Control


var current_3d_scene
var current_2d_scene
var current_gui_scene

var current_3d_scene_path: String


func _ready() -> void:
	Global.game_controller = self
	change_3d_scene("res://Level1.tscn")

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free() # Removes node entirely
		elif keep_running:
			current_gui_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_gui_scene) # Keeps in memory, does not run

	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new


func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free() # Removes node entirely
		elif keep_running:
			current_3d_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_3d_scene) # Keeps in memory, does not run

	var new = load(new_scene).instantiate()
	world_3d.add_child(new)
	current_3d_scene = new
	current_3d_scene_path = new_scene


func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free() # Removes node entirely
		elif keep_running:
			current_2d_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_2d_scene) # Keeps in memory, does not run

	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new


func reload_3d_scene() -> void:
	if current_3d_scene_path != "":
		change_3d_scene(current_3d_scene_path)

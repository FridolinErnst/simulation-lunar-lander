extends Area3D


func _ready():
	add_to_group("Crash")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	print("body entered")
	if body.is_in_group("Helicopter"):
		print("helicopter entered")
		body.crashed()

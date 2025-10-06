extends Area3D

func _ready():
	add_to_group("landing_pad")


func _on_body_entered(body: Node3D) -> void:
	print("body entered")
	if body.is_in_group("Helicopter"):
		print("helicopter entered")
		body.check_landing()

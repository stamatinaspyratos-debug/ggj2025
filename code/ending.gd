extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		Game.Player.state = "Stop"
		var t = create_tween()
	

extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		Game.hidden = true
		Game.Player.position.z = position.z + 0.3
		Game.Player.position.x += 0.3
 
func _on_body_exited(body: Node3D) -> void:
	if body == Game.Player:
		Game.hidden = false

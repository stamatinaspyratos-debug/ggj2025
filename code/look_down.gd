extends Area3D

var prev_offset: Vector3

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		prev_offset = Game.Camera.look_at_offset
		Game.Camera.look_at_offset.y = -1

func _on_body_exited(body: Node3D) -> void:
	if body == Game.Player:
		Game.Camera.look_at_offset.y = prev_offset.y

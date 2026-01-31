extends Area3D
@export var scene: PackedScene

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		get_tree().change_scene_to_packed(scene)

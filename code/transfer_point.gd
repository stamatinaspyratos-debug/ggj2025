extends Area3D
@export var scene: PackedScene
@export var keycard = 0

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		if keycard == 0:
			transfer()
		elif Game.Player.keycard == keycard:
			await Game.text(["This elevator needs a keycard.", "You have the correct keycard and can use it."])
			transfer()
		else:
			await Game.text(["This elevator needs a keycard.", "You don't have the correct keycard."])

func transfer():
	Game.elevator_effect()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed.call_deferred(scene)

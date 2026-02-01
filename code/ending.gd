extends Area3D

func _ready() -> void:
	$CanvasLayer.hide()

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		Game.Player.state = "Stop"
		Game.Camera.active = false
		var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		t.tween_property(Game.Camera, "position:x", $Jester.global_position.x, 2)
		$CanvasLayer.show()
		$AnimationPlayer.play("ending")
	

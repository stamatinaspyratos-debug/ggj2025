extends Area3D

func _ready() -> void:
	$CanvasLayer.hide()

func _on_body_entered(body: Node3D) -> void:
	if body == Game.Player:
		AudioServer.set_bus_volume_linear(1, 0)
		$AudioStreamPlayer.play()
		Game.Player.state = "Stop"
		Game.Camera.active = false
		var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		t.tween_property(Game.Camera, "position:x", $Jester.global_position.x, 2)
		$CanvasLayer.show()
		$AnimationPlayer.play("ending")
		await  $AnimationPlayer.animation_finished
		while not Input.is_action_pressed("ui_accept"):
			await get_tree().process_frame
		AudioServer.set_bus_volume_linear(1, 1)
		get_tree().change_scene_to_file("res://scene/Tutorial.tscn")
	

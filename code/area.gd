extends Node3D
class_name AreaNode

@export var player_scene: PackedScene
@export var in_title: bool = false

func _ready() -> void:
	Game.Area = self
	Game.Camera = $Camera
	add_player()
	if in_title:
		$TitleScreen.show()
		AudioServer.set_bus_volume_linear(1, 0)
		$TitleScreen/MainMenu.play()
		$TitleScreen/CreditContainer.hide()
	else: 
		if has_node("TitleScreen"): $TitleScreen.hide()
		Game.Player.state = "Idle"
		Game.Camera.active = true

func title_dismiss():
	$TitleScreen.hide()
	AudioServer.set_bus_volume_linear(1, 1)
	$TitleScreen/MainMenu.stop()
	$TitleScreen/Theme.stop()
	$Music.play(0)
	var t = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(
		Game.Camera, "position", Vector3(0, 2.822, 8), 1
	)
	t.tween_property(Game.Camera, "size", 4.5, 1)
	await t.finished
	Game.Player.state = "Idle"
	Game.Camera.active = true

func add_player():
	var player = player_scene.instantiate()
	add_child(player)
	if in_title: Game.Player.state = "Stop"
	player.name = "Player"
	player.masked = true
	Game.Camera.init()


func _on_credits_toggled(toggled_on: bool) -> void:
	$TitleScreen/CreditContainer.visible = toggled_on
	if toggled_on:
		$TitleScreen/MainMenu.stop()
		$TitleScreen/Theme.play()
	else:
		$TitleScreen/MainMenu.play()
		$TitleScreen/Theme.stop()

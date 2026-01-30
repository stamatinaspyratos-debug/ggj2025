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
	else: 
		if has_node("TitleScreen"): $TitleScreen.hide()
		Game.Player.state = "Idle"
		Game.Camera.active = true

func title_dismiss():
	$TitleScreen.hide()
	var t = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(
		Game.Camera, "position", Vector3(Game.Player.position.x, 2, 3), 1
	)
	t.tween_property(Game.Camera, "size", 5, 1)
	await t.finished
	Game.Player.state = "Idle"
	Game.Camera.active = true

func add_player():
	var player = player_scene.instantiate()
	add_child(player)
	player.name = "Player"
	player.masked = true
	Game.Camera.init()

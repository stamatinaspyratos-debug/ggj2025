extends Node3D

@export var player_scene: PackedScene
@export var in_title: bool = false
@export var camera_active = false

func _ready() -> void:
	Game.Camera = $Camera3D
	add_player()
	if in_title:
		$TitleScreen.show()
	else: 
		Game.Player.state = "Idle"
		camera_active = true

func title_dismiss():
	$TitleScreen.hide()
	var t = create_tween()
	t.tween_property(
		Game.Camera, "position", Game.Player.position + Vector3(0, 1, 3), 1
	)
	await t.finished
	Game.Player.state = "Idle"
	camera_active = true

func add_player():
	add_child(player_scene.instantiate())

func _process(_delta: float) -> void:
	if camera_active: camera_follow()

func camera_follow():
	Game.Camera.position.x = Game.Player.position.x

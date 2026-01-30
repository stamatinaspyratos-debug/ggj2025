extends Node3D
class_name AreaNode

@export var player_scene: PackedScene
@export var in_title: bool = false
@export var camera_active = false

func _ready() -> void:
	Game.Area = self
	Game.Camera = $Camera
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
	Game.Camera.init()

func _process(_delta: float) -> void:
	if camera_active: camera_follow()

func camera_follow():
	var t = create_tween().set_parallel()
	Game.Camera.position.x = Game.Player.position.x
	if Game.hidden:
		t.tween_property(Game.Camera, "rotation_degrees:y", -45, 0.2)
		t.tween_property(Game.Camera, "position:z", 3, 0.2)
	else: 
		t.tween_property(Game.Camera, "rotation_degrees:y", 0, 0.2)
		t.tween_property(Game.Camera, "position:z", 4, 0.2)

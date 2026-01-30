extends Node3D

@export var player_scene: PackedScene
@export var in_title: bool = false

func _ready() -> void:
	if in_title:
		$TitleScreen.show()
	else: add_player()

func title_dismiss():
	$TitleScreen.hide()
	$TitleScreen/Camera3D.current = false
	add_player()

func add_player():
	add_child(player_scene.instantiate())

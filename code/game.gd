extends Node

var Player: CharacterBody3D
var Camera: Node3D
var Area: AreaNode
var hidden:= false

func game_over():
	var scene = preload("res://scene/gameover.tscn").instantiate()
	get_tree().root.add_child(scene)
	while not Input.is_action_pressed("ui_accept"):
		Game.Player.state = "Stop"
		await get_tree().process_frame
	scene.queue_free()
	get_tree().change_scene_to_packed.call_deferred(load(Area.scene_file_path))

func game_over_fall():
	Camera.active = false
	elevator_effect()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed.call_deferred(load(Area.scene_file_path))

func mask_cutin():
	var scene = preload("res://scene/mask_cutin.tscn").instantiate()
	get_tree().root.add_child(scene)
	await get_tree().create_timer(1.5).timeout
	scene.queue_free()
	Player.state = "Idle"
	Camera.active = true

func text(texts: Array[String]):
	var scene = preload("res://scene/text.tscn").instantiate()
	Player.state = "Stop"
	get_tree().root.add_child(scene)
	await scene.show_text(texts)
	await get_tree().create_timer(0.3).timeout
	Player.state = "Idle"

func elevator_effect():
	var scene = preload("res://scene/elevator_arrow.tscn").instantiate()
	get_tree().root.add_child(scene)
	await get_tree().create_timer(3).timeout
	scene.queue_free()

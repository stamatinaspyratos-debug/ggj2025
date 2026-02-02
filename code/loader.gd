extends Control

func _ready() -> void:
	ProjectSettings.load_resource_pack("res://assets.pck")
	await get_tree().physics_frame
	get_tree().change_scene_to_file("res://scene/Tutorial.tscn")
	$Label.text = "Loading Failed!"

extends AnimatedSprite3D

@export var synced_properties: Array[String]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in synced_properties:
		set(i, get_parent().get(i))

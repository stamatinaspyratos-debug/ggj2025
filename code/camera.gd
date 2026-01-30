extends Node3D

@export var player_path: NodePath
@export var follow_smooth := 12.0

# κοντά + side view
@export var normal_offset := Vector3(0.0, 1.8, 2.4)
# angle όταν hidden (από “άλλη” πλευρά: X αρνητικό)
@export var hide_offset := Vector3(-1.2, 1.6, 2.0)

@export var look_at_offset := Vector3(0.0, 1.2, 0.0)

var player: Node
var target: Node3D
var active: bool = false

func init() -> void:
	player = Game.Player

	# αρχικός στόχος: ο Player
	target = player as Node3D

func _on_hidden_changed(v: bool) -> void:
	Game.hidden = v

func _on_control_target_changed(t: Node3D) -> void:
	target = t

func _process(delta: float) -> void:
	if target == null or not active:
		return

	# Αν ο Player είναι hidden, παίρνουμε angle (ακόμα κι αν οδηγείς NPC)
	# Αν θες το angle να ισχύει ΜΟΝΟ όταν target==Player, πες μου.
	var offset := hide_offset if (Game.hidden and target == player) else normal_offset

	var target_pos := target.global_position + offset
	global_position = global_position.lerp(target_pos, 1.0 - exp(-follow_smooth * delta))
	look_at(target.global_position + look_at_offset, Vector3.UP)

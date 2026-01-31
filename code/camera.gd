extends Camera3D

@export var player_path: NodePath
@export var follow_smooth := 12.0

# κοντά + side view
@export var normal_offset := Vector3(0.0, 3, 8)
# angle όταν hidden (από “άλλη” πλευρά: X αρνητικό)
@export var hide_offset := Vector3(-5, 8, 8)

@export var look_at_offset := Vector3(0, 1.2, 0)

var target: Node3D
var active: bool = false

func init() -> void:

	# αρχικός στόχος: ο Game.Player
	target = Game.Player as Node3D

func _on_hidden_changed(v: bool) -> void:
	Game.hidden = v

func _on_control_target_changed(t: Node3D) -> void:
	target = t

func _process(delta: float) -> void:
	near = 0
	if target == null or not active:
		return

	# Αν ο Game.Player είναι hidden, παίρνουμε angle (ακόμα κι αν οδηγείς NPC)
	# Αν θες το angle να ισχύει ΜΟΝΟ όταν target==Game.Player, πες μου.
	var offset := hide_offset if (Game.hidden and target == Game.Player) else normal_offset

	var target_pos := target.global_position + offset
	global_position = global_position.lerp(target_pos, 1.0 - exp(-follow_smooth * delta))
	look_at(target.global_position + look_at_offset, Vector3.UP)
	#position.y += 0.2

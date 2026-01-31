extends CharacterBody3D


@export var SPEED:= 3.0
@export var JUMP_VELOCITY = 8
@onready var sprite_mask: AnimatedSprite3D = $SpriteBase/SpriteMask
@onready var sprite_base: AnimatedSprite3D = $SpriteBase
@onready var detect_area: Area3D = $DetectArea
@onready var prompt:= $Prompt
var direction: Vector3
var masked:= false
@export var keycard:= 0
@export var can_catch_player:= false
@export var can_jump:= false
@export var sprite:= "Cat"

var sprite_offset: Dictionary = {
	"Cat": Vector3(0,0,0),
	"Human": Vector3(0,0.4,0),
}
var mask_offset: Dictionary = {
	"Cat": Vector3(0.28,0.13,0),
	"Human": Vector3(0,0.6,0),
}
@export var patrol:= false
@export_enum("Idle", "Walk", "Stop") var state = "Idle"
@export var path_follow: PathFollow3D

func _ready() -> void:
	Game.Player = self
	$Prompt.hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	# Get the input direction and handle the movement/deceleration.
	if masked:
		if not Game.Player == self:
			Game.Player.unmask()
			Game.Player = self
			state = "Idle"
			Game.Camera.target = self
			prompt.hide()
			direction = Vector3.ZERO
		if state != "Stop":
			control_walk()
			if can_jump:
				control_jump()
	elif patrol: patrol_process()
	
	if state == "Stop": direction = Vector3.ZERO
	
	if not masked and prompt.visible and Input.is_action_just_pressed("change_mask") and not Game.Player.state == "Stop":
		masked = true
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if direction.length() > 0 and state == "Idle": state = "Walk"
	if direction.length() == 0 and state == "Walk": state = "Idle"
	
	move_and_slide()
	animate()
	limit_position()

func control_walk():
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func control_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func animate():
	sprite_mask.visible = masked
	sprite_base.animation = sprite
	sprite_mask.position = mask_offset.get(sprite)
	if sprite_base.flip_h:
		sprite_mask.position.x *= -1 
		detect_area.position.x = -abs(detect_area.position.x)
	else:
		detect_area.position.x = abs(detect_area.position.x)
	sprite_mask.position.z = 0.1 
	sprite_base.position = sprite_offset.get(sprite)
	match state:
		"Walk":
			sprite_base.play()
			sprite_base.flip_h = direction.x < 0
		"Idle", "Stop":
			sprite_base.stop()
			sprite_base.frame = 0

func limit_position():
	position.z = clamp(position.z, -1, 3)

func patrol_process():
	if is_instance_valid(path_follow) and not state == "Stop":
		direction = to_local(path_follow.global_position)
		path_follow.progress += 0.01 * SPEED
		if direction.y > 1 and can_jump:
			velocity.y = JUMP_VELOCITY
		if direction.length() > 8 and is_on_floor():
			position = path_follow.position + Vector3(0, 1, 0)

func _on_ambush_area_body_entered(body: Node3D) -> void:
	if not masked and body == Game.Player:
		prompt.show()
		prompt.position = mask_offset.get(sprite) + Vector3(0,1,0)

func _on_ambush_area_body_exited(body: Node3D) -> void:
	if body == Game.Player:
		prompt.hide()

func _on_detect_area_body_entered(body: Node3D) -> void:
	if can_catch_player and not masked and body == Game.Player and not Game.hidden and not state == "Stop":
		Game.Player.state = "Stop"
		state = "Stop"
		Game.Camera.active = false
		velocity.y = JUMP_VELOCITY
		var t = create_tween().set_ease(Tween.EASE_OUT)
		t.tween_property(Game.Camera, "position:x", self.position.x, 0.3)
		await t.finished
		await get_tree().create_timer(0.5).timeout
		Game.game_over()

func unmask():
	Game.mask_cutin()
	Game.hidden = false
	masked = false
	direction = Vector3.ZERO
	state = "Stop"
	await get_tree().create_timer(3).timeout
	state = "Idle"
	

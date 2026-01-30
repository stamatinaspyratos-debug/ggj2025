extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 8
@onready var sprite_mask: AnimatedSprite3D = $SpriteBase/SpriteMask
@onready var sprite_base: AnimatedSprite3D = $SpriteBase
var direction: Vector3
var masked:= false
var can_jump:= false
var patrol:= false
@export_enum("Idle", "Walk", "Stop") var state = "Idle"
var path: Path3D
var path_follow: PathFollow3D

func _ready() -> void:
	Game.Player = self
	if has_node("Path3D"): 
		path = get_node("Path3D")
		path_follow = get_node("PathFollow3D")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	# Get the input direction and handle the movement/deceleration.
	if masked:
		if not Game.Player == self:
			Game.Player.masked = false
			Game.Player = self
			state = "Idle"
			Game.Camera.target = self
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if state != "Stop":
			control_walk()
			if can_jump:
				control_jump()
	
	if direction.length() > 0 and state == "Idle": state = "Walk"
	if direction.length() == 0 and state == "Walk": state = "Idle"
	
	move_and_slide()
	animate()
	limit_position()

func control_walk():
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func control_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func animate():
	match state:
		"Walk":
			sprite_base.play()
			$SpriteBase.flip_h = direction.x < 0
		"Idle":
			sprite_base.stop()
			sprite_base.frame = 0

func limit_position():
	position.z = clamp(position.z, -1, 3)

func patrol_process():
	if is_instance_valid(path_follow):
		direction = to_local(path_follow.position)

extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var sprite_mask: AnimatedSprite3D = $SpriteBase/SpriteMask
@onready var sprite_base: AnimatedSprite3D = $SpriteBase
var direction: Vector3
var state = IDLE
enum {IDLE, WALK, STOP}
@export_enum("Normal", "Fly") var moveset = "Normal"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if direction.length() > 0 and state == IDLE: state = WALK
	if direction.length() == 0 and state == WALK: state = IDLE
	
	if state != STOP:
		move_and_slide()
	animate()
	
func animate():
	match state:
		WALK:
			sprite_base.play()
			$SpriteBase.flip_h = direction.x < 0
		IDLE:
			sprite_base.stop()
			sprite_base.frame = 0

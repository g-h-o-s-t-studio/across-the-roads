extends CharacterBody3D

const SPEED: float = 7.0
const JUMP_VELOCITY: float = 4.5
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: Vector3 = Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_left"):
		direction.z -= 1
	if Input.is_action_pressed("ui_right"):
		direction.z += 1
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()

extends CharacterBody3D

const JUMP_VELOCITY: float = 7.0

var player_speed: float = 7.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: Vector3 = Vector3(0, 0, 1)
	if Input.is_action_pressed("ui_left"):
		direction.x += 1
	if Input.is_action_pressed("ui_right"):
		direction.x -= 1

	# player_speed += 0.01

	velocity.x = direction.x * player_speed
	velocity.z = direction.z * player_speed
	move_and_slide()


# FIXME
func _on_area_body_entered(body) -> void:
	if body is Obstacle:
		print("--------------Died!----------------")

	if body is Coin:
		body.queue_free()


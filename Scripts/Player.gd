class_name Player extends CharacterBody3D

const JUMP_VELOCITY: float = 7.0
const START_POSITION: Vector3 = Vector3.ZERO

var coins: int = 0
var player_speed: float = 12.0
var player_speed_horizontally: float = 20.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta: float) -> void:
	ScoreManager.score = get_current_score()


func get_current_score() -> int:
	return int(global_transform.origin.distance_to(START_POSITION))


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
	direction = direction.normalized()
	velocity.x = direction.x * player_speed_horizontally
	velocity.z = direction.z * player_speed
	
	move_and_slide()


# FIXME
func _on_area_body_entered(body) -> void:
	if body is Obstacle:
		print("--------------Died!----------------")

	if body is Coin:
		body.queue_free()



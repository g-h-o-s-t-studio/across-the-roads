class_name Player extends CharacterBody3D

const JUMP_VELOCITY: float = 7.0

var player_speed: float = 12.0
var player_speed_horizontally: float = 20.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta: float) -> void:
	# get current score
	ScoreManager.score = int(global_transform.origin.distance_to(Vector3.ZERO))


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


#func make_transparent_if_close(node: Node3D, distance_threshold: float):
	#var distance = (node.global_transform.origin - get_viewport().get_camera().global_transform.origin).length()
	#if distance < distance_threshold:
		#var material = node.get_surface_material(0) as StandardMaterial3D
		#material.albedo_color.a = 0.5
	#else:
		#var material = node.get_surface_material(0) as StandardMaterial3D
		#material.albedo_color.a = 1.0


# FIXME
func _on_area_body_entered(body) -> void:
	if body is BaseObstacle:
		print("died")
	#if body is Coin:
		#body.queue_free()


func _on_area_area_entered(area):
	var any_area = area.get_parent()
	if any_area is Coin:
		any_area.queue_free()
	#print(area.get_parent().get_parent())
	#if area is Coin:
		#area.get_parent().queue_free()

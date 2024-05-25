class_name Player extends CharacterBody3D

const JUMP_VELOCITY = 7.0

var _player_speed := 12.0
var _player_speed_horizontally := 20.0
var _gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float


func _process(_delta: float) -> void:
	# get current score
	ScoreManager.score = int(global_transform.origin.distance_to(Vector3.ZERO))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: Vector3 = Vector3(0, 0, 1)
	if Input.is_action_pressed("ui_left"):
		direction.x += 1
	if Input.is_action_pressed("ui_right"):
		direction.x -= 1

	# player_speed += 0.01
	direction = direction.normalized()
	velocity.x = direction.x * _player_speed_horizontally
	velocity.z = direction.z * _player_speed
	
	move_and_slide()


#func make_transparent_if_close(node: Node3D, distance_threshold: float):
	#var distance = (node.global_transform.origin - get_viewport().get_camera().global_transform.origin).length()
	#if distance < distance_threshold:
		#var material = node.get_surface_material(0) as StandardMaterial3D
		#material.albedo_color.a = 0.5
	#else:
		#var material = node.get_surface_material(0) as StandardMaterial3D
		#material.albedo_color.a = 1.0


func dead() -> void:
	# как в субвей серфе?
	#free()
	pass


func _on_area_body_entered(body: Node3D) -> void:
	if body is BaseObstacle:
		dead()


func _on_area_area_entered(area: Area3D) -> void:
	var any_area := area.get_parent()
	if any_area is Coin:
		any_area.free()

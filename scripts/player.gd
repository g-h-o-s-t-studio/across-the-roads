class_name Player extends CharacterBody3D

@export var speed := 7.0

const JUMP_VELOCITY = 7.0

var gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float


func _process(_delta: float) -> void:
	# get current score
	# FIXME: поменять чтобы считало только по оси z!!!
	ScoreManager.score = int(global_transform.origin.z)
	speed += 0.000223


func _physics_process(delta: float) -> void:
	var x := 0.0
	if Input.is_action_pressed("ui_left"):
		x += 1.0
	if Input.is_action_pressed("ui_right"):
		x -= 1.0
	
	velocity.x = x * speed
	velocity.z = speed
	
	var on_floor := is_on_floor()
	if Input.is_action_just_pressed("ui_accept") and on_floor:
		velocity.y = JUMP_VELOCITY
	
	if not on_floor:
		velocity.y -= gravity * delta
	
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

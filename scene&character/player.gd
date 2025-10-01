extends CharacterBody3D


@export_group("Movement")
## Character maximum run speed on the ground in meters per second.
@export var move_speed := 8.0
## Ground movement acceleration in meters per second squared.
@export var acceleration := 20.0
## When the player is on the ground and presses the jump button, the vertical
## velocity is set to this value.
@export var jump_impulse := 12.0
## Player model rotation speed in arbitrary units. Controls how fast the
## character skin orients to the movement or camera direction.
@export var rotation_speed := 12.0
## Minimum horizontal speed on the ground. This controls when the character skin's
## animation tree changes between the idle and running states.
@export var stopping_speed := 1.0

@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 30.0

@export var speed = 30
@export var camera_speed = 2
@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var _skin = $Player_model
@onready var _attack_box = $AttackColli
var is_attacking = false




var ground_height := 0.0

var _gravity := -30.0
var _was_on_floor_last_frame := true
var _camera_input_direction := Vector2.ZERO

## The last movement or aim direction input by the player. We use this to orient
## the character model.
@onready var _last_input_direction := global_basis.z
# We store the initial position of the player to reset to it when the player falls off the map.
@onready var _start_position := global_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player_model/Lucien.finish_attack.connect(on_finish_attack)
	$Player_model/Lucien/AnimationPlayer.play("Lucien/Idle")




# Use _physics_process for all physics-related code.
func _physics_process(delta):
	# For a 3D game, we still use get_vector() to get a Vector2 for the horizontal plane.
	var raw_input = Vector2.ZERO
	if !is_attacking:
		raw_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward", 0.4)

	# Take the input vector and transform it by the body's basis (its rotation).
	# This makes the movement relative to where the player is facing.
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction = forward * raw_input.y + right * raw_input.x
	
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	# To not orient the character too abruptly, we filter movement inputs we
	# consider when turning the skin. This also ensures we have a normalized
	# direction for the rotation basis.
	if move_direction.length() > 0.2:
		_last_input_direction = move_direction.normalized()
	var target_angle := Vector3.BACK.signed_angle_to(_last_input_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)
	_attack_box.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)


	
	
	
	# We separate out the y velocity to only interpolate the velocity in the
	# ground plane, and not affect the gravity.
	var y_velocity = velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	if is_equal_approx(move_direction.length_squared(), 0.0) and velocity.length_squared() < stopping_speed:
		velocity = Vector3.ZERO
	velocity.y = y_velocity + _gravity * delta

	# Character animations and visual effects.
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	var is_just_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_just_jumping:
		velocity.y += jump_impulse
		$Player_model/Lucien/AnimationPlayer.play("Lucien/Jump")
	
	
	
	
	_was_on_floor_last_frame = is_on_floor()
	move_and_slide()
	
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	
	if Input.is_action_pressed("camera_left"):
		_camera_pivot.rotation.y += camera_speed * delta
		
	if Input.is_action_pressed("camera_right"):
		_camera_pivot.rotation.y += -camera_speed * delta
		
	if Input.is_action_pressed("camera_up"):
		_camera_pivot.rotation.x += -camera_speed * delta

	if Input.is_action_pressed("camera_down"):
		_camera_pivot.rotation.x += camera_speed * delta
	# Create a target velocity.
	
	
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") && !is_attacking:
		normal_attack()
		is_attacking = true
		print("endable")
	
	
		
		
func normal_attack():
	$AttackColli/normalAttack.disabled = false
	$Player_model/Lucien/AnimationPlayer.play("Lucien/Attack1")


func _on_attack_collion_body_entered(body: Node3D) -> void:
	print(body.get_groups())

	print("enemy hit")
	$AttackColli/normalAttack.disabled = true
	is_attacking = false
	

func on_finish_attack():
	is_attacking = false
	$AttackColli/normalAttack.disabled = true
	$Player_model/Lucien/AnimationPlayer.play("Lucien/Idle")


#func _on_attack_window_timeout() -> void:
	#$attackCollion/normalAttack.disabled = true
	#is_attacking = false
	#print("disable")

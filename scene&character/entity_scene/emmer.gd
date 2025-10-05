extends CharacterBody3D

@onready var target = get_node("../Player")
@onready var animation_tree = $EmmerrichTextureAndAnimation/AnimationTree

@export var SPEED: float = 1.0
@export var FOLLOW_DISTANCE: float = 14.0
@export var STOPPING_DISTANCE: float = 1.0
var is_player = false


var gravity = - 30




func _ready() -> void:
	print(get_node("../Player"))

func _physics_process(delta: float) -> void:
	# Always apply gravity
	velocity.y += gravity * delta
	
	var distance_to_target = position.distance_to(target.position)
	
	# Only follow if the target is close enough, but not too close
	if distance_to_target < FOLLOW_DISTANCE and !is_player:
		# Look at the target
		look_at(target.position)
		if !is_player:
			# Calculate direction
			var direction = (target.position - position).normalized()
			
			# Set velocity directly instead of accelerating
			# We preserve the vertical velocity for gravity/jumping
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		# Stop moving if we are too close or too far
		velocity.x = 0
		velocity.z = 0
		
	_animation_handling()
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_player = true
		print("player in attack range")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_player = false
		print("player exits attack range")


func _on_attack_colli_body_entered(body: Node3D) -> void:
	print("attack",body)
	
func _animation_handling():
	if velocity != Vector3.ZERO:
		
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idle"] = false
	else :
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idle"] = true

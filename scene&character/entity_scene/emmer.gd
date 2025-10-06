extends CharacterBody3D

@onready var target = get_node("../Player")
@onready var animation_tree =  $EmmerrichTextureAndAnimation2/AnimationTree

@export var SPEED: float = 2.0
@export var FOLLOW_DISTANCE: float = 14.0
@export var STOPPING_DISTANCE: float = 1.0
var is_player = false
var is_attack = false
@export var health = 100
@export var max_health = 100
@export var attack = 10
var damage = 0



var gravity = - 30




func _ready() -> void:
	print(get_node("../Player"))
	$EmmerrichTextureAndAnimation2.finish_attack.connect(_on_finished_attack)
	$EmmerrichTextureAndAnimation2.finish_death.connect(death_handling)

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
	_attack_handling()
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
	perform_attack(body)
	
func _animation_handling():
	
	
	
	if velocity.x != 0 && velocity.y != 0 && !is_player :
		animation_tree["parameters/conditions/is_jump_slash"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idle"] = false
	elif velocity.x != 0 && velocity.y != 0 && is_player:
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_holding_sword"] = true
	elif velocity.x == 0 && velocity.y == 0 && !is_player :
		
		
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle"] = true
		
		
func _attack_handling():
	if is_player && !is_attack && $"JumpAttack Cooldown".is_stopped() && $AttackCooldown.is_stopped():
		damage = attack * 2
		$AttackColli/AttackBox.disabled = false
		is_attack = true
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_normalSlash"] = false
		animation_tree["parameters/conditions/is_jump_slash"] = true
	elif  is_player && !is_attack && $AttackCooldown.is_stopped():
		damage = attack
		$AttackColli/AttackBox.disabled = false
		is_attack = true
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_jump_slash"] = false
		animation_tree["parameters/conditions/is_normalSlash"] = true
	
	
	
func _on_finished_attack(attacktype):
	
	$AttackColli/AttackBox.disabled = true
	$AttackCooldown.start()
	if attacktype == "jumpSlash":
		$"JumpAttack Cooldown".start()
	is_attack = false
	animation_tree["parameters/conditions/is_normalSlash"] = false
	animation_tree["parameters/conditions/is_holding_sword"] = true
func perform_attack(body: Node3D):
	if body.is_in_group("Player"):
		body.take_damage(damage)


func take_damage(damage):
	if health > 0:
		health -= damage
		print("emmer hp is ",health)
		if health <= 0:
			
			animation_tree["parameters/conditions/is_death"] = true
			
func death_handling():
	queue_free()

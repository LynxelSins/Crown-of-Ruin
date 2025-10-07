extends CharacterBody3D

@onready var purple_bullet_scene = preload("res://entity_scene/purple_bullet.tscn")
@onready var bullet_fire_rate = $Timer/bullet_fire_rate
@onready var bullet_cool_down = $Timer/bullet_cooldown
@onready var bullet_fire_time = $Timer/bullet_firetime
@onready var sword_red_bullet = preload("res://sword_bullet.tscn")
@onready var sword_blue = preload("res://blue_sword.tscn")
@onready var player = get_node("../Player")

var is_red_sword_cooldown = false
var sword_counter = 0
@export var health = 500
@export var max_health = 500
@export var red_sword_number = 8
@export var speed = 50
var is_player = false
var is_blue_sword_activated = false
var target_walk = Vector3.ZERO
@onready var initial_pos = position
func _ready() -> void:
	bullet_fire_time.start()
	var random_offset = Vector3(
		randf_range(-10, 10),  # Random X position
		0,    # Random Y position
		randf_range(-10, 10)   # Random Z position
	)
	
	target_walk = initial_pos + random_offset


func _process(delta: float) -> void:
	if health <= 0:
		GameManager.is_first_state_done = true
			
		queue_free()

func _physics_process(delta: float) -> void:
	if is_player:
		var direction = (target_walk - position).normalized()
		velocity = direction * speed * delta
		
		move_and_slide()
		
		
		
		
		
		
		if bullet_fire_rate.is_stopped() && bullet_cool_down.is_stopped():
			
			_spawn_purple_bullet_front()
			_spawn_purple_bullet_right()
			_spawn_purple_bullet_back()
			_spawn_purple_bullet_left()
		if $Timer/sword_summon_cooldown.is_stopped():
			if sword_counter >= red_sword_number:
				$Timer/sword_summon_cooldown.start()
				sword_counter = 0;
			elif $Timer/sword_summon_rate.is_stopped():
				_spawn_sword_red()
	
	
func _spawn_sword_red():
	$Sword_magic2.play()
	sword_counter +=1
	$Timer/sword_summon_rate.start()
	var new_sword = sword_red_bullet.instantiate()
	
	var random_offset = Vector3(
		randf_range(-10, 10),  # Random X position
		randf_range(1, 10),    # Random Y position
		randf_range(-10, 10)   # Random Z position
	)
	get_tree().current_scene.add_child(new_sword)
	new_sword.global_position = $Muzzlepoint/front.global_position + random_offset
	
	
func _spawn_purple_bullet_front():
	bullet_fire_rate.start()
	var new_bullet = purple_bullet_scene.instantiate()
	
	
	get_tree().current_scene.add_child(new_bullet)
	var fire_direction = $Muzzlepoint/front.global_transform.basis.z
	new_bullet.global_position = $Muzzlepoint/front.global_position
	new_bullet.direction = fire_direction

func _spawn_purple_bullet_back():
	bullet_fire_rate.start()
	var new_bullet = purple_bullet_scene.instantiate()
	
	
	get_tree().current_scene.add_child(new_bullet)
	var fire_direction = -$Muzzlepoint/back.global_transform.basis.z
	new_bullet.global_position = $Muzzlepoint/back.global_position
	new_bullet.direction = fire_direction
	
func _spawn_purple_bullet_right():
	
	bullet_fire_rate.start()
	var new_bullet = purple_bullet_scene.instantiate()
	new_bullet.is_side = true
	
	get_tree().current_scene.add_child(new_bullet)
	var fire_direction = $Muzzlepoint/right.global_transform.basis.x
	new_bullet.global_position = $Muzzlepoint/right.global_position
	new_bullet.direction = fire_direction
	
func _spawn_purple_bullet_left():
	
	bullet_fire_rate.start()
	var new_bullet = purple_bullet_scene.instantiate()
	new_bullet.is_side = true
	
	get_tree().current_scene.add_child(new_bullet)
	var fire_direction = -$Muzzlepoint/left.global_transform.basis.x
	new_bullet.global_position = $Muzzlepoint/left.global_position
	new_bullet.direction = fire_direction
	




func _on_bullet_firetime_timeout() -> void:
	
	bullet_cool_down.start()


func _on_bullet_cooldown_timeout() -> void:
	
	bullet_fire_time.start()


func _on_sword_summon_cooldown_timeout() -> void:
	print("done cd red sword")
	
func _activate_blue_sword():
	$Sword_magic.play()

	var new_sword = sword_blue.instantiate()
	
	var random_offset = Vector3(
		randf_range(-10, 10),  # Random X position
		randf_range(1, 10),    # Random Y position
		randf_range(-10, 10)   # Random Z position
	)
	get_tree().current_scene.add_child(new_sword)
	new_sword.global_position = $Muzzlepoint/front.global_position + random_offset
	
	
	
	
func take_damage(damage):
	is_player = true
	_activate_blue_sword()
	_activate_blue_sword()
	if health > 0:
		health -= damage
		print("beatrice hp is ",health)
		if health < 0:
			GameManager.is_first_state_done = true
			
			queue_free()


func _on_walking_timer_timeout() -> void:
	var random_offset = Vector3(
		randf_range(-5, 5),  # Random X position
		0,    # Random Y position
		randf_range(-5, 5)   # Random Z position
	)
	
	target_walk = initial_pos + random_offset

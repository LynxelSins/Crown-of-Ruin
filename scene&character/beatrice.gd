extends CharacterBody3D

@onready var purple_bullet_scene = preload("res://entity_scene/purple_bullet.tscn")
@onready var bullet_fire_rate = $Timer/bullet_fire_rate
@onready var bullet_cool_down = $Timer/bullet_cooldown
@onready var bullet_fire_time = $Timer/bullet_firetime


func _ready() -> void:
	bullet_fire_time.start()

func _physics_process(delta: float) -> void:
	if bullet_fire_rate.is_stopped() && bullet_cool_down.is_stopped():
		pass
		#_spawn_purple_bullet_front()
		#_spawn_purple_bullet_right()
		#_spawn_purple_bullet_back()
		#_spawn_purple_bullet_left()
	
	
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
	print("cooldown")
	bullet_cool_down.start()


func _on_bullet_cooldown_timeout() -> void:
	print("done cd")
	bullet_fire_time.start()

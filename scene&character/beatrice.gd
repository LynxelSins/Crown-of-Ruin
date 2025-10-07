extends CharacterBody3D

@onready var purple_bullet_scene = preload("res://entity_scene/purple_bullet.tscn")
@onready var bullet_timer_1 = $Timer/BulletTimer1


func _physics_process(delta: float) -> void:
	if bullet_timer_1.is_stopped():
		_spawn_purple_bullet()
	
	
func _spawn_purple_bullet():
	bullet_timer_1.start()
	var new_bullet = purple_bullet_scene.instantiate()
	
	
	get_tree().current_scene.add_child(new_bullet)
	var fire_direction = -$Muzzlepoint/Front.global_transform.basis.z
	new_bullet.global_position = $Muzzlepoint/Front.global_position
	new_bullet.direction = fire_direction

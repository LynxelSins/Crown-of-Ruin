extends CharacterBody3D

var direction
@export var speed = 600
var is_side = false
func _ready() -> void:
	$AudioStreamPlayer.play()
	$Timer.start()
	if !direction:
		direction = $model.global_transform.basis.z
	if is_side:
		# Set all rotation components to (0, 90, 0)
		$model.global_rotation = Vector3(0, 90, 0)
		$Hitbox.global_rotation = Vector3(0, 90, 0)
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	
	move_and_slide()
	
	
	
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("Player"):
		body.take_damage(10)
		$Hitbox/CollisionShape3D.set_deferred("disabled",true)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

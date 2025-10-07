extends CharacterBody3D

var direction
var speed = 3000

func _ready() -> void:
	print("spawn")
	if !direction:
		direction = -$model.global_transform.basis.z
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	
	move_and_slide()
	
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("hitplayer")
		$Hitbox/CollisionShape3D.disabled = true

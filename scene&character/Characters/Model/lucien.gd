extends Node3D

signal finish_attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Lucien/Attack1":
		finish_attack.emit("attack1")
	elif anim_name == "Lucien/Attack2":
		finish_attack.emit("attack2")
	elif anim_name == "Lucien/Attack3":
		finish_attack.emit("attack3")

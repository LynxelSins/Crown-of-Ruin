extends Node3D


signal finish_attack
signal finish_death

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "normalSlash":
		finish_attack.emit("normalSlash")
	elif anim_name == "jumpSlash":
		finish_attack.emit("jumpSlash")
	if anim_name == "death":
		finish_death.emit()

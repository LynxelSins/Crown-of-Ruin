extends Node2D
func _on_button_pressed() -> void:
	SceneTransition.load_scene(preload("res://Scene/main.tscn"))
	

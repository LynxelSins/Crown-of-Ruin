extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.is_first_state_done = false
	GameManager.is_second_state_done = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/first_stage.tscn")

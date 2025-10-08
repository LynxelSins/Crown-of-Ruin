extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && GameManager.is_second_state_done:
		SceneTransition.load_scene(preload("res://Scene/main_3.tscn"))
		
	elif body.is_in_group("Player") && GameManager.is_first_state_done:
		SceneTransition.load_scene(preload("res://Scene/second_stage.tscn"))
	

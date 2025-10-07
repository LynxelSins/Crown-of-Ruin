extends CanvasLayer

@onready var dash_cooldown_bar = $DashCoolDown/ProgressBar2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if dash_cooldown_bar.value == dash_cooldown_bar.max_value:
		
		dash_cooldown_bar.value = 0
		$DashCoolDown.visible = false
	
	
	pass


func set_health_bar(health):
	$ProgressBar.value = health



func start_dash_cooldown():
	$DashCoolDown.visible = true
	$DashCoolDown/ProgressBar2.value = 0
	var tween = create_tween()
	tween.tween_property($DashCoolDown/ProgressBar2, "value", $DashCoolDown/ProgressBar2.max_value, 2)

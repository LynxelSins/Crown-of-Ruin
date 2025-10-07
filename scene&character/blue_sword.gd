extends CharacterBody3D

# --- Configuration Exports ---
@export var speed = 25              # Movement speed when in the MOVE_TO_TARGET state
@export var rotation_speed = 5.0    # Controls how fast the smooth look happens (Higher = Faster)
@export var look_time = 1.5            # Time spent in the SMOOTH_LOOK state (seconds)
@export var wait_time = 1.5            # Time spent in the WAIT_BEFORE_MOVE state (seconds)
@export var target_reached_threshold = 0.1 # Distance threshold to consider the target reached
@export var damage = 5
@onready var target = get_node("../Player")
# --- State Management ---
enum State {
	IDLE,               # Waiting for a new target or instruction
	SMOOTH_LOOK,        # Smoothly rotating towards the target position
	WAIT_BEFORE_MOVE,   # Pausing after looking, before starting movement
	MOVE_TO_TARGET      # Moving forward in the direction faced
}

var current_state = State.IDLE

var timer = 0.0                 # Timer used to track time in the SMOOTH_LOOK and WAIT states

func _ready() -> void:
	print("spawn blue")
	look_time = randf_range(0,2)
	wait_time = randf_range(0,2)
	$TrackCooldown.start()
	
	

# --- External Call to Start the Sequence ---
func engage_target(position):
	"""
	Called externally (e.g., from an area signal or game logic) to start the sequence.
	"""
	
	target = position
	timer = 0.0 
	current_state = State.SMOOTH_LOOK


# --- Main Game Loop ---
func _physics_process(delta):
	
		match current_state:
			State.SMOOTH_LOOK:
				# Step 1: Smoothly rotate to face the target
				smooth_look_at(target, delta)
				timer += delta
				
				# Transition condition: Look time elapsed
				if timer >= look_time:
					timer = 0.0
					
					current_state = State.WAIT_BEFORE_MOVE
					
			State.WAIT_BEFORE_MOVE:
				# Step 2: Wait for the specified time
				# We keep velocity at zero and don't move during this phase
				velocity = Vector3.ZERO
				move_and_slide() 
				timer += delta
				
				# Transition condition: Wait time elapsed
				if timer >= wait_time:
					
					current_state = State.MOVE_TO_TARGET
					timer = 0.0
					
			State.MOVE_TO_TARGET:
				# Step 3: Move towards the target position
				move_towards_target(delta)
				
				# Transition condition: Target reached
				if global_position.distance_to(target) < target_reached_threshold:
					velocity = Vector3.ZERO
					
					
					current_state = State.IDLE
					
			
			State.IDLE:
				# Nothing happening, just apply physics to prevent sinking/floating
				velocity = Vector3.ZERO
				move_and_slide()


# --- Helper Functions ---

func smooth_look_at(target_position: Vector3, delta: float):
	"""
	Interpolates the rotation from the current rotation to the target rotation.
	This replaces the instant look_at() call.
	"""
	
	# 1. Calculate the desired Transform to look at the target (Vector3.UP is the up vector)
	var target_transform = global_transform.looking_at(target_position, Vector3.UP)
	
	# 2. Interpolate the current transform towards the desired transform
	# The 'rotation_speed * delta' determines the interpolation factor (0.0 to 1.0)
	# Using 'rotation_speed' makes the rotation speed framerate-independent.
	global_transform = global_transform.interpolate_with(target_transform, rotation_speed * delta)

	# Ensure movement stops during the looking phase
	velocity = Vector3.ZERO
	move_and_slide()


func move_to_random(_delta: float):
	print("move to random")
	var random_offset = Vector3(
		randf_range(-10, 10),  # Random X position
		randf_range(1, 10),    # Random Y position
		randf_range(-10, 10)   # Random Z position
	)
	
	var target_position = target.position + random_offset
	
	var direction = (target_position - position).normalize
	velocity = direction * speed
	move_and_slide()
	
func move_towards_target(_delta: float):
	var direction = -global_transform.basis.z 
	velocity = direction * speed
	$TrackCooldown.start()
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Area3D/CollisionShape3D.set_deferred("disabled",true)
		body.take_damage(damage)
		queue_free()
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Area3D/CollisionShape3D.set_deferred("disabled",false)
		


func _on_track_cooldown_timeout() -> void:
	print("blue cooldown done")
	engage_target(target.position)


func _on_timer_timeout() -> void:
	queue_free()

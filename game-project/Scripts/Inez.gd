extends NPC

@export var walk_speed: float = 80.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	super()
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 8.0

func walk_to(target: Vector2) -> void:
	interaction_area.set_deferred("monitoring", false)
	InteractionManager.unregister_area(interaction_area)
	animated_sprite_2d.play("walk")
	nav_agent.target_position = target
	await get_tree().physics_frame

	while not nav_agent.is_navigation_finished():
		var next: Vector2 = nav_agent.get_next_path_position()
		var direction := (next - global_position).normalized()
		global_position += direction * walk_speed * get_physics_process_delta_time()
		animated_sprite_2d.flip_h = direction.x < 0
		await get_tree().physics_frame

	global_position = target
	animated_sprite_2d.play("idle")
	interaction_area.set_deferred("monitoring", true)

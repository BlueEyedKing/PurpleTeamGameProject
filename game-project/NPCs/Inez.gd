extends NPC

@export var walk_speed: float = 80.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func walk_to(target: Vector2) -> void:
	interaction_area.set_process(false)
	animated_sprite_2d.play("walk")
	while global_position.distance_to(target) > 4.0:
		var direction = (target - global_position).normalized()
		global_position += direction * walk_speed * get_process_delta_time()
		animated_sprite_2d.flip_h = direction.x < 0
		await get_tree().process_frame
	global_position = target
	animated_sprite_2d.play("idle")
	interaction_area.set_process(true)

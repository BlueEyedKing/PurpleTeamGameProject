extends CharacterBody2D
class_name Player

@export var SPEED: float = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	update_animation(input_direction)
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func update_animation(direction) -> void:
	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
		return
		
	if direction.x > 0:
		animated_sprite_2d.play("right")
	if direction.x < 0:
		animated_sprite_2d.play("left")
	if direction.y > 0:
		animated_sprite_2d.play("down")
	if direction.y < 0:
		animated_sprite_2d.play("up")

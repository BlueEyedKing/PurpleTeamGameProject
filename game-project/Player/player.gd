extends CharacterBody2D
class_name Player

@export var SPEED: float = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _input_locked := false

func _ready() -> void:
	add_to_group("player")
	EventBus.minigame_started.connect(func(): _input_locked = true)
	EventBus.minigame_finished.connect(func(): _input_locked = false)

func get_input() -> void:
	if _input_locked:
		velocity = Vector2.ZERO
		return
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	update_animation(input_direction)

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func update_animation(direction) -> void:
	if not animated_sprite_2d:
		return
	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
		return

	if direction.x > 0:
		animated_sprite_2d.play("right")
	elif direction.x < 0:
		animated_sprite_2d.play("left")
	elif direction.y > 0:
		animated_sprite_2d.play("down")
	elif direction.y < 0:
		animated_sprite_2d.play("up")

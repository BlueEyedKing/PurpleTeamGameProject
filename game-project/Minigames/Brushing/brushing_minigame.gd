extends Control

## Brushing Minigame — Hold LMB and drag to brush dirt off a fossil.
## Call start(fossil_texture) to begin. Emits brushing_finished when done.

signal brushing_finished(success: bool, clean_percentage: float)

const MASK_SIZE := 256
const BRUSH_RADIUS := 20
const CLEAN_THRESHOLD := 0.80
const TIME_LIMIT := 30.0

@onready var fossil_sprite: TextureRect = %FossilSprite
@onready var dirt_overlay: ColorRect = %DirtOverlay
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_label: Label = %ProgressLabel
@onready var instruction_label: Label = %InstructionLabel
@onready var time_label: Label = %TimeLabel
@onready var result_label: Label = %ResultLabel
@onready var title_label: Label = %TitleLabel

var mask_image: Image
var mask_texture: ImageTexture
var total_pixels: int
var dirty_pixels: int
var clean_percentage := 0.0
var time_remaining: float = TIME_LIMIT
var _active := false
var _finished := false

func start(fossil_texture: Texture2D) -> void:
	fossil_sprite.texture = fossil_texture
	_setup_mask()
	_active = true
	_finished = false
	time_remaining = TIME_LIMIT
	clean_percentage = 0.0
	result_label.hide()
	instruction_label.show()
	_update_progress_display()
	show()
	# Hide the system cursor while brushing
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _setup_mask() -> void:
	mask_image = Image.create(MASK_SIZE, MASK_SIZE, false, Image.FORMAT_L8)
	mask_image.fill(Color.WHITE)
	mask_texture = ImageTexture.create_from_image(mask_image)

	var material = dirt_overlay.material as ShaderMaterial
	material.set_shader_parameter("mask_texture", mask_texture)

	total_pixels = MASK_SIZE * MASK_SIZE
	dirty_pixels = total_pixels

func _process(delta: float) -> void:
	if not _active:
		return

	# Countdown timer
	time_remaining -= delta
	time_label.text = "Time: %d" % ceili(time_remaining)

	# Flash timer red when low
	if time_remaining <= 5.0:
		time_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	else:
		time_label.remove_theme_color_override("font_color")

	if time_remaining <= 0.0:
		_finish(false)
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_brush_at_mouse()

func _brush_at_mouse() -> void:
	var local_pos = dirt_overlay.get_local_mouse_position()
	var overlay_size = dirt_overlay.size

	if local_pos.x < 0 or local_pos.x > overlay_size.x:
		return
	if local_pos.y < 0 or local_pos.y > overlay_size.y:
		return

	var uv_x = local_pos.x / overlay_size.x
	var uv_y = local_pos.y / overlay_size.y
	var mask_x = int(uv_x * MASK_SIZE)
	var mask_y = int(uv_y * MASK_SIZE)

	var changed := false
	for dy in range(-BRUSH_RADIUS, BRUSH_RADIUS + 1):
		for dx in range(-BRUSH_RADIUS, BRUSH_RADIUS + 1):
			if dx * dx + dy * dy <= BRUSH_RADIUS * BRUSH_RADIUS:
				var px = mask_x + dx
				var py = mask_y + dy
				if px >= 0 and px < MASK_SIZE and py >= 0 and py < MASK_SIZE:
					if mask_image.get_pixel(px, py).r > 0.5:
						mask_image.set_pixel(px, py, Color.BLACK)
						dirty_pixels -= 1
						changed = true

	if changed:
		mask_texture.update(mask_image)
		clean_percentage = 1.0 - (float(dirty_pixels) / float(total_pixels))
		_update_progress_display()

		if clean_percentage >= CLEAN_THRESHOLD:
			_finish(true)

func _update_progress_display() -> void:
	var pct = int(clean_percentage * 100)
	progress_label.text = "%d%%" % pct
	progress_bar.value = pct

func _finish(success: bool) -> void:
	if _finished:
		return
	_finished = true
	_active = false

	# Restore mouse
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	instruction_label.hide()
	result_label.show()

	if success:
		result_label.text = "Fossil Cleaned!"
		result_label.add_theme_color_override("font_color", Color(0.3, 1, 0.4))
	else:
		result_label.text = "Time's Up!"
		result_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))

	await get_tree().create_timer(1.5).timeout
	brushing_finished.emit(success, clean_percentage)

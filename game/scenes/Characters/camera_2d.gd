extends Camera2D

# ---- НОВОЕ: к какому TileMap привязываемся ----
@export var tilemap: TileMap

# Настройки зума
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 5.0
@export var initial_zoom: float = 3.0

# Плавность зума
@export var smooth_zoom: bool = true
@export var zoom_smoothness: float = 10.0

var target_zoom: Vector2

func _ready():
	
	# Инициализация начального зума
	zoom = Vector2(initial_zoom, initial_zoom)
	target_zoom = zoom

	# ---- НОВОЕ: выставляем лимиты по размеру TileMap ----
	_update_limits_from_tilemap()

func _process(delta):
	handle_zoom_input()
	if smooth_zoom:
		zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)
	else:
		zoom = target_zoom

func handle_zoom_input():
	if Input.is_action_just_released("zoom_in"):
		zoom_in()
	elif Input.is_action_just_released("zoom_out"):
		zoom_out()

	if Input.is_key_pressed(KEY_EQUAL):
		zoom_in()
	elif Input.is_key_pressed(KEY_MINUS):
		zoom_out()

func zoom_in():
	var new_zoom = target_zoom.x - zoom_speed
	target_zoom = Vector2(clamp(new_zoom, min_zoom, max_zoom), clamp(new_zoom, min_zoom, max_zoom))

func zoom_out():
	var new_zoom = target_zoom.x + zoom_speed
	target_zoom = Vector2(clamp(new_zoom, min_zoom, max_zoom), clamp(new_zoom, min_zoom, max_zoom))

func set_zoom_level(level: float):
	target_zoom = Vector2(clamp(level, min_zoom, max_zoom), clamp(level, min_zoom, max_zoom))

func reset_zoom():
	target_zoom = Vector2(initial_zoom, initial_zoom)

# ---- НОВАЯ ФУНКЦИЯ ДЛЯ ЛИМИТОВ ----
func _update_limits_from_tilemap():
	if tilemap == null:
		return

	var rect: Rect2i = tilemap.get_used_rect()
	var cell: Vector2i = tilemap.tile_set.tile_size

	limit_left   = rect.position.x * cell.x
	limit_top    = rect.position.y * cell.y
	limit_right  = (rect.position.x + rect.size.x) * cell.x
	limit_bottom = (rect.position.y + rect.size.y) * cell.y

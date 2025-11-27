extends Camera2D

# Настройки зума
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var initial_zoom: float = 1.0

# Плавность зума
@export var smooth_zoom: bool = true
@export var zoom_smoothness: float = 10.0

var target_zoom: Vector2

func _ready():
	# Инициализация начального зума
	zoom = Vector2(initial_zoom, initial_zoom)
	target_zoom = zoom

func _process(delta):
	# Обработка ввода для зума
	handle_zoom_input()
	
	# Плавное применение зума
	if smooth_zoom:
		zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)
	else:
		zoom = target_zoom

func handle_zoom_input():
	# Зум колесиком мыши
	if Input.is_action_just_released("zoom_in"):
		zoom_in()
	elif Input.is_action_just_released("zoom_out"):
		zoom_out()
	
	# Зум клавишами (опционально)
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

# Функция для установки конкретного значения зума
func set_zoom_level(level: float):
	target_zoom = Vector2(clamp(level, min_zoom, max_zoom), clamp(level, min_zoom, max_zoom))

# Функция для сброса зума к начальному значению
func reset_zoom():
	target_zoom = Vector2(initial_zoom, initial_zoom)

extends RigidBody2D

@onready var arrow: Sprite2D = $"Arrow"
@onready var stretch_sound: AudioStreamPlayer2D = $"StretchAudio2D"
@onready var launch_sound: AudioStreamPlayer2D = $"LaunchAudio2D"
@onready var kick_wood_sound: AudioStreamPlayer2D = $"KickWood2D"

const DRAG_MAX: Vector2 = Vector2(0, 60)
const DRAG_MIN: Vector2 = Vector2( - 60, 0)
const IMPULSE_MULTIPLIER: float = 20.0
const IMPULSE_MAX: float = 1200.0

enum PARROT_STATE {READY, DRAG, RELEASE}

var _parrot_state: PARROT_STATE = PARROT_STATE.READY
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _drag_vector: Vector2 = Vector2.ZERO
var _prev_drag_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0
var _last_contact_count: int = 0
var _has_exited_screen: bool = false

func _ready() -> void:
	arrow.hide()
	_start = position
	_arrow_scale_x = arrow.scale.x

func _physics_process(_delta: float) -> void:
	update()

func set_parrot_state(state: PARROT_STATE) -> void:
	_parrot_state = state
	if _parrot_state == PARROT_STATE.RELEASE:
		set_release()
	elif _parrot_state == PARROT_STATE.DRAG:
		set_drag()

func set_release() -> void:
	arrow.hide()
	freeze = false
	apply_central_impulse(get_impulse())
	launch_sound.play()
	SignalBus.on_attempt.emit()

func set_drag() -> void:
	_drag_start = get_global_mouse_position()
	arrow.show()

func get_impulse() -> Vector2:
	return _drag_vector * - 1 * IMPULSE_MULTIPLIER

func detect_release() -> bool:
	if _parrot_state == PARROT_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_parrot_state(PARROT_STATE.RELEASE)
			return true
	return false

func scale_arrow() -> void:
	var impulse_len: float = get_impulse().length()
	var percentage: float = impulse_len / IMPULSE_MAX
	arrow.scale.x = _arrow_scale_x * percentage + _arrow_scale_x
	arrow.rotation = (_start - position).angle()

func play_drag_sound() -> void:
	if (_prev_drag_vector - _drag_vector).length() != 0:
		if !stretch_sound.playing:
			stretch_sound.play()

func get_drag_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start

func drag_in_limits() -> void:
	_prev_drag_vector = _drag_vector
	_drag_vector.x = clampf(_drag_vector.x, DRAG_MIN.x, DRAG_MAX.x)
	_drag_vector.y = clampf(_drag_vector.y, DRAG_MIN.y, DRAG_MAX.y)
	position = _start + _drag_vector

func update_drag() -> void:
	if detect_release():
		return
	var gmp: Vector2 = get_global_mouse_position()
	_drag_vector = get_drag_vector(gmp)
	play_drag_sound()
	drag_in_limits()
	scale_arrow()

func play_collision() -> void:
	if _last_contact_count == 0 and get_contact_count() > 0 and !kick_wood_sound.playing:
		kick_wood_sound.play()
	_last_contact_count = get_contact_count()

func update_flight() -> void:
	if _has_exited_screen:
		if position.x > get_viewport_rect().size.x:
			die()
	play_collision()

func update() -> void:
	match _parrot_state:
		PARROT_STATE.READY:
			pass
		PARROT_STATE.DRAG:
			update_drag()
		PARROT_STATE.RELEASE:
			update_flight()

func die() -> void:
	SignalBus.on_parrot_died.emit()
	queue_free()

func _on_screen_exited() -> void:
	if position.y < 0 and position.x > 0 and position.x < get_viewport_rect().size.x:
		_has_exited_screen = true
		return
	die()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _parrot_state == PARROT_STATE.READY and event.is_action_pressed("drag"):
		set_parrot_state(PARROT_STATE.DRAG)

func _on_sleeping_state_changed() -> void:
	if sleeping:
		var collided_bodies: Array[Node2D] = get_colliding_bodies()
		if collided_bodies.size() > 0:
			if collided_bodies[0].has_method("die"):
				collided_bodies[0].die()
		die()

func _on_screen_entered() -> void:
	_has_exited_screen = false

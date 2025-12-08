extends Control

const MENU_CONFIRM = preload("uid://21iio861j1ek")

@onready var buttons: VBoxContainer = $Buttons
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	modulate.a = 0.0
	buttons.hide()
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.2)
	await t.finished
	buttons.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		leave()

func leave() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	buttons.hide()
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.2)
	await t.finished
	queue_free()

func _on_resume_clicked() -> void:
	AudioManager.play_sfx(MENU_CONFIRM)
	leave()

func _on_quit_clicked() -> void:
	AudioManager.play_sfx(MENU_CONFIRM)
	buttons.hide()
	var t = create_tween()
	t.tween_property(color_rect, "color", Color.BLACK, 1.0)
	await t.finished
	get_tree().quit()

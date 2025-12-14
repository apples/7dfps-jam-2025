extends Node

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_F11:
			get_window().mode = Window.MODE_FULLSCREEN if get_window().mode != Window.MODE_FULLSCREEN else Window.MODE_WINDOWED

extends Area3D

func _init() -> void:
	var timer := Timer.new()
	timer.autostart = true
	timer.wait_time = 0.5
	timer.timeout.connect(_on_timeout)
	add_child(timer, false, Node.INTERNAL_MODE_FRONT)

func _on_timeout() -> void:
	for body in get_overlapping_bodies():
		if "hurt" in body:
			body.hurt()

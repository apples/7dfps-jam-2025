extends HurtboxArea3D

@export var speed: float = TAU
@export var radius: float = 5.0
@export var skip_time: float = 0.0

var _time: float = 0.0

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $CollisionShape3D/AudioStreamPlayer3D
@onready var timer: Timer = $Timer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	_time += delta
	var a := fposmod((_time + skip_time) * speed, TAU)
	rotation.x = a
	collision_shape_3d.rotation.x += speed * delta * 2.0

func _on_audio_stream_player_3d_finished() -> void:
	audio_stream_player_3d.pitch_scale = randf_range(0.7, 0.9)
	audio_stream_player_3d.play()


func _on_timer_timeout() -> void:
	clear()


func _on_hit_something() -> void:
	collision_shape_3d.disabled = true
	timer.start()
	collision_shape_3d.disabled = false

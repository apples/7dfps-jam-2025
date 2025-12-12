extends Area3D

const TOCK = preload("uid://bn6txgo4rja5i")

@export var velocity: Vector3
@export var caster: Node3D

@onready var bone: MeshInstance3D = $Bone

func _process(delta: float) -> void:
	bone.rotation.y += 1.0 * delta
	bone.rotation.x += 3.0 * delta

func _physics_process(delta: float) -> void:
	position += velocity * delta;

func _on_body_entered(body: Node3D) -> void:
	if is_queued_for_deletion():
		return
	if body != caster:
		if "hurt" in body:
			body.hurt()
		AudioManager.play_sfx_3d(TOCK, global_position)
		queue_free()

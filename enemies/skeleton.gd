extends CharacterBody3D


const SPEED = 5.0
const FIREBOLT = preload("uid://ibo6d2umlxhy")

var target: Node3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var vision_ray_cast: RayCast3D = $VisionRayCast
@onready var bt_player: BTPlayer = $BTPlayer
@onready var firebolt_marker_3d: Marker3D = get_node_or_null("FireboltMarker3D")

func _physics_process(delta: float) -> void:
	bt_player.update(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	animation_tree["parameters/IdleRunBlendSpace/blend_position"] = Vector3(velocity.x, 0, velocity.z).length() / SPEED

func hurt() -> void:
	var bones = preload("res://enemies/skeleton_bone_explode.tscn").instantiate()
	bones.position = position
	get_parent().add_child(bones)
	queue_free()

func update_target() -> void:
	bt_player.blackboard.set_var("target", target)
	
	if not target:
		bt_player.blackboard.set_var("target_in_sight", false)
		return
	
	vision_ray_cast.target_position = vision_ray_cast.to_local(target.global_position + Vector3(0, 1.5, 0))
	vision_ray_cast.force_raycast_update()
	
	if vision_ray_cast.get_collider() == target:
		bt_player.blackboard.set_var("target_in_sight", true)
		navigation_agent.target_position = target.global_position
	else:
		bt_player.blackboard.set_var("target_in_sight", false)

func shoot_bone() -> void:
	if not target or not firebolt_marker_3d:
		return
	var target_vec := target.global_position - global_position
	global_basis = Basis.looking_at(target_vec * Vector3(1, 0, 1), Vector3.UP, true)
	var firebolt := FIREBOLT.instantiate() as Node3D
	firebolt.position = get_parent().to_local(to_global(firebolt_marker_3d.position))
	firebolt.velocity = target_vec.normalized() * 12.0
	firebolt.caster = self
	get_parent().add_child(firebolt)

func _on_detection_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body
		update_target()

func _on_detection_area_3d_body_exited(body: Node3D) -> void:
	if target == body:
		target = null
		update_target()

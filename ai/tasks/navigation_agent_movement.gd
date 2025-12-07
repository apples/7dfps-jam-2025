@tool
extends BTAction

@export var navigation_agent_path: NodePath = "NavigationAgent3D"
@export var speed_var: StringName = &"speed"
@export var acceleration_var: StringName = &"acceleration"

func _generate_name() -> String:
	return "NavAgent Movement -> ^\"%s\" ($%s, $%s)" % [navigation_agent_path, speed_var, acceleration_var]

func _tick(delta: float) -> Status:
	var navigation_agent := scene_root.get_node(navigation_agent_path) as NavigationAgent3D
	
	if not navigation_agent:
		return FAILURE
	
	var next_pos := navigation_agent.get_next_path_position()
	
	var c_agent := agent as CharacterBody3D
	var speed: float = blackboard.get_var(speed_var, 1.0)
	var acceleration: float = blackboard.get_var(acceleration_var, 1.0)
	
	var dir := c_agent.global_position.direction_to(next_pos)
	dir = Vector3(dir.x, 0, dir.z).normalized()
	
	var ideal_velocity = speed * dir
	ideal_velocity.y = c_agent.velocity.y
	c_agent.velocity = c_agent.velocity.move_toward(ideal_velocity, acceleration * delta)
	
	var planar_vel := Vector3(c_agent.velocity.x, 0, c_agent.velocity.z)
	
	if not planar_vel.is_zero_approx():
		c_agent.global_basis = Basis.looking_at(planar_vel, Vector3.UP,  true)
	
	if navigation_agent.is_target_reached():
		return SUCCESS
	
	return RUNNING

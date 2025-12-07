@tool
extends BTAction

@export var acceleration: float = 200.0

func _tick(delta: float) -> Status:
	var c_agent = self.agent as CharacterBody3D
	var ideal_velocity := Vector3(0, c_agent.velocity.y, 0)
	c_agent.velocity = c_agent.velocity.move_toward(ideal_velocity, delta * acceleration)
	if Vector2(c_agent.velocity.x, c_agent.velocity.z).is_zero_approx():
		return Status.SUCCESS
	return Status.RUNNING

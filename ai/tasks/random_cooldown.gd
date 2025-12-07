@tool
extends BTDecorator

@export var min_duration: float = 1.0
@export var max_duration: float = 1.0
@export var process_pause: bool = false
@export var start_cooled: bool = false
@export var trigger_on_failure: bool = false
@export var cooldown_state_var: StringName

var _timer: SceneTreeTimer

func _generate_name() -> String:
	return "Random Cooldown %s-%s sec" % [snappedf(min_duration, 0.001), snappedf(max_duration, 0.001)]

func _setup() -> void:
	if cooldown_state_var == StringName():
		cooldown_state_var = "cooldown_%d" % get_instance_id()
	
	blackboard.set_var(cooldown_state_var, false)
	
	if start_cooled:
		_chill()

func _tick(delta: float) -> Status:
	assert(get_child_count() == 1, "BT decorator has no child.")
	if blackboard.get_var(cooldown_state_var, true):
		return FAILURE
	
	var child_status: Status = get_child(0).execute(delta)
	
	if child_status == SUCCESS or (trigger_on_failure and child_status == FAILURE):
		_chill()
	
	return child_status

func _chill() -> void:
	blackboard.set_var(cooldown_state_var, true)
	var duration := randf_range(min_duration, max_duration)
	if _timer:
		_timer.time_left = duration
	else:
		_timer = agent.get_tree().create_timer(duration, process_pause)
		assert(_timer)
		_timer.timeout.connect(_on_timeout, CONNECT_ONE_SHOT)

func _on_timeout() -> void:
	blackboard.set_var(cooldown_state_var, false)
	_timer = null

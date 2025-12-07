@tool
extends BTAction

@export var animation_tree_path: NodePath = "AnimationTree"
@export var one_shot_path: String

func _generate_name() -> String:
	return "Fire OneShot %s" % [one_shot_path]

func _enter() -> void:
	scene_root.get_node(animation_tree_path)[one_shot_path + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _exit() -> void:
	if status == RUNNING:
		scene_root.get_node(animation_tree_path)[one_shot_path + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT

func _tick(_delta: float) -> Status:
	if scene_root.get_node(animation_tree_path)[one_shot_path + "/active"]:
		return Status.RUNNING
	return Status.SUCCESS

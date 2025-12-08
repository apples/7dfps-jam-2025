extends Resource
class_name WeaponArchetype

@export var name: String
@export var model: PackedScene
@export var attack_anim: StringName = &"sword"
@export var attack_anim_speed: float = 1.0
@export var stamina_cost: int = 100

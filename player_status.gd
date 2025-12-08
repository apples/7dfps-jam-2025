extends Resource
class_name PlayerStatus

@export var max_hp: int = 100
@export var current_hp: int = 100
@export var max_stamina: int = 100
@export var current_stamina: int = 100
@export var stamina_recovery_per_sec: int = 50
@export var sprint_stamina_per_sec: int = 25

@export var equipped_weapon: WeaponArchetype

extends "res://addons/fpc/character.gd"

@onready var player_ui_animation_player: AnimationPlayer = $PlayerUI/PlayerUIAnimationPlayer
@onready var weapon_animations: AnimationPlayer = $WeaponAnimations

func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)
	
	if event.is_action_pressed("attack"):
		weapon_animations.play("sword")

func hurt() -> void:
	player_ui_animation_player.play("hurt")

extends "res://addons/fpc/character.gd"

const PAUSE_MENU = preload("uid://deabhxcs4fsqn")

@onready var player_ui_animation_player: AnimationPlayer = $PlayerUI/PlayerUIAnimationPlayer
@onready var weapon_animations: AnimationPlayer = $WeaponAnimations
@onready var interact_ray_cast: RayCast3D = %InteractRayCast

func _enter_tree() -> void:
	Globals.player = self

func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)
	
	if event.is_action_pressed("attack"):
		weapon_animations.play("sword")
	
	if event.is_action_pressed("interact"):
		if interact_ray_cast.is_colliding():
			var interactable := interact_ray_cast.get_collider() as Interactable
			if interactable:
				interactable.interact()
	
	if event.is_action_pressed("pause"):
		var menu = PAUSE_MENU.instantiate()
		Globals.menu_canvas_layer.add_child(menu)

func hurt() -> void:
	player_ui_animation_player.play("hurt")

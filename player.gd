extends "res://addons/fpc/character.gd"

signal respawn_request()

const PAUSE_MENU = preload("uid://deabhxcs4fsqn")
const OOF = preload("uid://cau7886fgih4k")
const RUN_HINT_CD = 15.0

const FOOTSTEPS = [
	preload("uid://gvaxs1s02pma"),
	preload("uid://bkm4xv4y7sdhe"),
	preload("uid://b0tljmmb50he5"),
	preload("uid://c7e4i46q6gf7i"),
	preload("uid://dqc6nl7m6yboy"),
]

var status: PlayerStatus = PlayerStatus.new()

var stamina_accum: float = 0.0
var stamina_recovery_buffer: int = 0

var weapon_node: Node3D

var input_disabled: bool = false
var invulnerable: bool = false

var run_hint_cooldown: float = 0.0

@onready var player_ui_animation_player: AnimationPlayer = $PlayerUI/PlayerUIAnimationPlayer
@onready var weapon_animations: AnimationPlayer = $WeaponAnimations
@onready var interact_ray_cast: RayCast3D = %InteractRayCast
@onready var weapon_marker: Marker3D = %WeaponMarker
@onready var run_hint_label: Label = %RunHintLabel

func _enter_tree() -> void:
	Globals.player = self
	status.respawn_point = global_position

func _ready():
	super._ready()
	equip_weapon(preload("res://weapons/sword_archetype.tres"))
	run_hint_label.modulate.a = 0.0

func _process(delta: float) -> void:
	super._process(delta)
	
	if state == "sprinting":
		stamina_accum -= delta * status.sprint_stamina_per_sec
		stamina_recovery_buffer = maxi(stamina_recovery_buffer, 20)
	else:
		stamina_accum += delta * status.stamina_recovery_per_sec
	
	var stamina_change := int(stamina_accum)
	if stamina_change != 0:
		stamina_accum -= stamina_change
		if stamina_change > 0:
			stamina_recovery_buffer -= stamina_change
			stamina_change = 0
			if stamina_recovery_buffer < 0:
				stamina_change = -stamina_recovery_buffer
				stamina_recovery_buffer = 0
		status.current_stamina = clampi(status.current_stamina + stamina_change, 0, status.max_stamina)
	
	run_hint_cooldown -= delta

func _unhandled_input(event: InputEvent) -> void:
	if input_disabled:
		return
	
	super._unhandled_input(event)
	
	if not weapon_animations.is_playing():
		if status.current_stamina > 0 and event.is_action_pressed("attack"):
			weapon_animations.speed_scale = status.equipped_weapon.attack_anim_speed
			status.current_stamina -= status.equipped_weapon.stamina_cost
			stamina_recovery_buffer = 50
			if status.current_stamina < 0:
				status.current_stamina = 0
				weapon_animations.speed_scale *= 0.5
				stamina_recovery_buffer *= 2
			weapon_animations.play(status.equipped_weapon.attack_anim)
		elif status.current_stamina <= 0 and run_hint_cooldown <= 0 and event.is_action_pressed("attack"):
			run_hint_cooldown = RUN_HINT_CD
			var t := create_tween()
			t.tween_property(run_hint_label, "modulate:a", 1.0, 1.0)
			t.tween_interval(1.0)
			t.tween_property(run_hint_label, "modulate:a", 0.0, 1.0)
	
	if event.is_action_pressed("interact"):
		if interact_ray_cast.is_colliding():
			var interactable := interact_ray_cast.get_collider()
			if "interact" in interactable:
				interactable.interact()
	
	if event.is_action_pressed("pause"):
		var menu = PAUSE_MENU.instantiate()
		Globals.menu_canvas_layer.add_child(menu)
	
	if OS.is_debug_build():
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_HOME:
				position = Vector3(0, 1, -108)

func equip_weapon(weapon: WeaponArchetype) -> void:
	status.equipped_weapon = weapon
	if weapon_node:
		weapon_node.queue_free()
	weapon_node = weapon.model.instantiate()
	weapon_marker.add_child(weapon_node)

func hurt() -> void:
	if invulnerable:
		return
	player_ui_animation_player.play("hurt")
	status.current_hp -= 10
	AudioManager.play_sfx(OOF)
	if status.current_hp <= 0:
		die()

func rest() -> void:
	player_ui_animation_player.play("wake")
	status.current_hp = status.max_hp
	status.current_stamina = status.max_stamina
	stamina_recovery_buffer = 0
	stamina_accum = 0

func die() -> void:
	weapon_animations.stop()
	player_ui_animation_player.play("death")
	immobile = true
	input_disabled = true
	invulnerable = true
	set_physics_process(false)
	
	await player_ui_animation_player.animation_finished
	respawn_request.emit()
	
	immobile = false
	input_disabled = false
	invulnerable = false
	velocity = Vector3.ZERO
	wind_velocity = Vector3.ZERO
	set_physics_process(true)


func _on_footstep() -> void:
	AudioManager.play_sfx(FOOTSTEPS.pick_random(), 0.2, 1.2)

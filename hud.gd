extends Control

const HP_SIZE_RATIO = 200.0 / 100.0
const STAMINA_SIZE_RATIO = 200.0 / 100.0

@onready var hp_bar: ColorRect = %HpBar
@onready var hp_bar_fill: ColorRect = %HpBarFill
@onready var stamina_bar: ColorRect = %StaminaBar
@onready var stamina_bar_fill: ColorRect = %StaminaBarFill

func _process(_delta: float) -> void:
	if Globals.player and Globals.player.status:
		hp_bar.size.x = Globals.player.status.max_hp * HP_SIZE_RATIO
		hp_bar_fill.size.x = Globals.player.status.current_hp * HP_SIZE_RATIO
		stamina_bar.size.x = Globals.player.status.max_stamina * STAMINA_SIZE_RATIO
		stamina_bar_fill.size.x = Globals.player.status.current_stamina * STAMINA_SIZE_RATIO

extends Control
class_name LevelupScene

## Pool of modifiers to roll to populate GUI
@export var modifier_pool : ModifierPool

## Modifiers to show in the GUI as selection options. Rolled for by the modifier_pool
var rolled_modifiers : Array[ModifierBase]

@onready var panel1 : Panel = $BoxContainer/MarginContainer/Selection1Panel
@onready var panel2 : Panel = $BoxContainer/MarginContainer2/Selection2Panel
@onready var panel3 : Panel = $BoxContainer/MarginContainer3/Selection3Panel

@onready var icon1 : TextureRect = $BoxContainer/MarginContainer/CenterContainer/VBoxContainer/AspectRatioContainer/TextureRect
@onready var name1 : Label = $BoxContainer/MarginContainer/CenterContainer/VBoxContainer/ModName
@onready var desc1 : Label = $BoxContainer/MarginContainer/CenterContainer/VBoxContainer/ModDescription
@onready var flavor1 : Label = $BoxContainer/MarginContainer/CenterContainer/VBoxContainer/FlavorText

@onready var icon2 : TextureRect = $BoxContainer/MarginContainer2/CenterContainer/VBoxContainer/AspectRatioContainer/TextureRect
@onready var name2 : Label = $BoxContainer/MarginContainer2/CenterContainer/VBoxContainer/ModName
@onready var desc2 : Label = $BoxContainer/MarginContainer2/CenterContainer/VBoxContainer/ModDescription
@onready var flavor2 : Label = $BoxContainer/MarginContainer2/CenterContainer/VBoxContainer/FlavorText

@onready var icon3 : TextureRect = $BoxContainer/MarginContainer3/CenterContainer/VBoxContainer/AspectRatioContainer/TextureRect
@onready var name3 : Label = $BoxContainer/MarginContainer3/CenterContainer/VBoxContainer/ModName
@onready var desc3 : Label = $BoxContainer/MarginContainer3/CenterContainer/VBoxContainer/ModDescription
@onready var flavor3 : Label = $BoxContainer/MarginContainer3/CenterContainer/VBoxContainer/FlavorText


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Roll modifiers
	rolled_modifiers = modifier_pool.roll_for_modifiers(3)
	
	# Update UI
	if rolled_modifiers.size() > 0:
		update_modifier_ui_element(icon1, name1, desc1, flavor1, rolled_modifiers[0])
	if rolled_modifiers.size() > 1:
		update_modifier_ui_element(icon2, name2, desc2, flavor2, rolled_modifiers[1])
	if rolled_modifiers.size() > 2:
		update_modifier_ui_element(icon3, name3, desc3, flavor3, rolled_modifiers[2])
	
	# Hookup signals
	if rolled_modifiers.size() > 0:
		panel1.mouse_entered.connect(_on_mouseover_panel.bind(panel1))
		panel1.mouse_exited.connect(_on_mouse_exit_panel.bind(panel1))
		panel1.gui_input.connect(_on_input_event.bind(0))
	
	if rolled_modifiers.size() > 1:
		panel2.mouse_entered.connect(_on_mouseover_panel.bind(panel2))
		panel2.mouse_exited.connect(_on_mouse_exit_panel.bind(panel2))
		panel2.gui_input.connect(_on_input_event.bind(1))
	
	if rolled_modifiers.size() > 2:
		panel3.mouse_entered.connect(_on_mouseover_panel.bind(panel3))
		panel3.mouse_exited.connect(_on_mouse_exit_panel.bind(panel3))
		panel3.gui_input.connect(_on_input_event.bind(2))


func _on_mouseover_panel(panel : Panel):
	panel.theme_type_variation = "Selected"


func _on_mouse_exit_panel(panel : Panel):
	panel.theme_type_variation = ""
	
	
func _on_input_event(event : InputEvent, panel_index : int):
	if event.is_action_pressed("mouse_left_click"):
		apply_modifier(panel_index)
	
	
func apply_modifier(selection : int):
	print(rolled_modifiers[selection].modifier_name)
	SignalBroker.apply_levelup_modifier.emit(rolled_modifiers[selection])
	SignalBroker.level_up_selection_complete.emit()
	

func update_modifier_ui_element(icon : TextureRect, mod_name : Label, mod_desc : Label, flavor_text : Label, mod : ModifierBase):
	icon.texture = mod.icon_texture
	mod_name.text = mod.modifier_name
	mod_desc.text = mod.description
	flavor_text.text = mod.flavor_text

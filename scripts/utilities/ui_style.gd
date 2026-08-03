class_name UiStyle
extends RefCounted
## Shared postcard/travel colors for built-in Godot controls.

const NAVY := Color("121A33")
const PANEL_VIOLET := Color("3A2F55")
const PANEL_VIOLET_LIGHT := Color("4A3A6A")
const GOLD := Color("FFD666")
const TEXT_LIGHT := Color("F5F0E6")
const TEXT_MUTED := Color("C9C0D9")
const DANGER := Color("E08A8A")
const SUCCESS := Color("9AD4A6")


static func apply_panel(panel: PanelContainer) -> void:
	if panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_VIOLET
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_right = 16
	style.corner_radius_bottom_left = 16
	style.content_margin_left = 16
	style.content_margin_top = 16
	style.content_margin_right = 16
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)


static func apply_primary_button(button: Button) -> void:
	if button == null:
		return
	button.custom_minimum_size = Vector2(0, 56)
	button.add_theme_font_size_override("font_size", 20)
	var normal := StyleBoxFlat.new()
	normal.bg_color = GOLD
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_right = 12
	normal.corner_radius_bottom_left = 12
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_color_override("font_color", NAVY)
	button.add_theme_color_override("font_hover_color", NAVY)
	button.add_theme_color_override("font_pressed_color", NAVY)
	button.add_theme_color_override("font_disabled_color", Color(NAVY, 0.55))


static func apply_secondary_button(button: Button) -> void:
	if button == null:
		return
	button.custom_minimum_size = Vector2(0, 56)
	button.add_theme_font_size_override("font_size", 18)
	var normal := StyleBoxFlat.new()
	normal.bg_color = PANEL_VIOLET_LIGHT
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_right = 12
	normal.corner_radius_bottom_left = 12
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_color_override("font_color", TEXT_LIGHT)


static func apply_body_label(label: Label, muted: bool = false) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", TEXT_MUTED if muted else TEXT_LIGHT)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


static func apply_title_label(label: Label) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 34)
	label.add_theme_color_override("font_color", GOLD)


static func apply_line_edit(edit: LineEdit) -> void:
	if edit == null:
		return
	edit.custom_minimum_size = Vector2(0, 52)
	edit.add_theme_font_size_override("font_size", 20)

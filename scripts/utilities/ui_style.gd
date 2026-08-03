class_name UiStyle
extends RefCounted
## Postcard / travel visual language for built-in Godot controls.

const NAVY := Color("121A33")
const NAVY_DEEP := Color("0B1226")
const PANEL_VIOLET := Color("3A2F55")
const PANEL_VIOLET_LIGHT := Color("4A3A6A")
const PANEL_VIOLET_DEEP := Color("2A2340")
const GOLD := Color("FFD666")
const GOLD_DIM := Color("C9A84A")
const TEXT_LIGHT := Color("F5F0E6")
const TEXT_MUTED := Color("C9C0D9")
const DANGER := Color("E08A8A")
const SUCCESS := Color("9AD4A6")


static func _rounded_box(
	color: Color,
	radius: int = 14,
	margin: int = 14,
	border_color: Color = Color(0, 0, 0, 0),
	border_width: int = 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
	style.content_margin_left = margin
	style.content_margin_top = margin
	style.content_margin_right = margin
	style.content_margin_bottom = margin
	if border_width > 0:
		style.border_width_left = border_width
		style.border_width_top = border_width
		style.border_width_right = border_width
		style.border_width_bottom = border_width
		style.border_color = border_color
	return style


static func apply_panel(panel: PanelContainer, stamped: bool = false) -> void:
	if panel == null:
		return
	if stamped:
		panel.add_theme_stylebox_override(
			"panel",
			_rounded_box(PANEL_VIOLET, 18, 16, GOLD_DIM, 2)
		)
	else:
		panel.add_theme_stylebox_override("panel", _rounded_box(PANEL_VIOLET, 16, 14))


static func apply_hero_panel(panel: PanelContainer) -> void:
	if panel == null:
		return
	panel.add_theme_stylebox_override(
		"panel",
		_rounded_box(PANEL_VIOLET_DEEP, 20, 18, GOLD, 3)
	)


static func apply_metric_panel(panel: PanelContainer) -> void:
	if panel == null:
		return
	panel.add_theme_stylebox_override(
		"panel",
		_rounded_box(PANEL_VIOLET_LIGHT, 12, 12, Color(GOLD.r, GOLD.g, GOLD.b, 0.35), 1)
	)


static func apply_primary_button(button: Button) -> void:
	if button == null:
		return
	button.custom_minimum_size = Vector2(0, 58)
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_stylebox_override("normal", _rounded_box(GOLD, 14, 14))
	button.add_theme_stylebox_override("hover", _rounded_box(Color("FFE08A"), 14, 14))
	button.add_theme_stylebox_override("pressed", _rounded_box(GOLD_DIM, 14, 14))
	button.add_theme_stylebox_override("disabled", _rounded_box(Color("8A7A45"), 14, 14))
	button.add_theme_color_override("font_color", NAVY)
	button.add_theme_color_override("font_hover_color", NAVY)
	button.add_theme_color_override("font_pressed_color", NAVY_DEEP)
	button.add_theme_color_override("font_disabled_color", Color(NAVY, 0.55))


static func apply_secondary_button(button: Button) -> void:
	if button == null:
		return
	button.custom_minimum_size = Vector2(0, 54)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_stylebox_override(
		"normal",
		_rounded_box(PANEL_VIOLET_LIGHT, 14, 14, Color(GOLD.r, GOLD.g, GOLD.b, 0.45), 1)
	)
	button.add_theme_color_override("font_color", TEXT_LIGHT)


static func apply_nav_button(button: Button, active: bool) -> void:
	if button == null:
		return
	button.custom_minimum_size = Vector2(0, 58)
	button.add_theme_font_size_override("font_size", 15)
	button.clip_text = true
	button.modulate = Color.WHITE
	if active:
		button.add_theme_stylebox_override("disabled", _rounded_box(GOLD, 12, 8))
		button.add_theme_stylebox_override("normal", _rounded_box(GOLD, 12, 8))
		button.add_theme_color_override("font_color", NAVY)
		button.add_theme_color_override("font_disabled_color", NAVY)
	else:
		button.add_theme_stylebox_override(
			"normal",
			_rounded_box(PANEL_VIOLET_LIGHT, 12, 8, Color(TEXT_LIGHT.r, TEXT_LIGHT.g, TEXT_LIGHT.b, 0.15), 1)
		)
		button.add_theme_stylebox_override("hover", _rounded_box(PANEL_VIOLET, 12, 8, GOLD_DIM, 1))
		button.add_theme_stylebox_override("pressed", _rounded_box(PANEL_VIOLET_DEEP, 12, 8, GOLD, 1))
		button.add_theme_color_override("font_color", TEXT_LIGHT)
		button.add_theme_color_override("font_hover_color", GOLD)
		button.add_theme_color_override("font_pressed_color", GOLD)


static func apply_bottom_nav(panel: PanelContainer) -> void:
	if panel == null:
		return
	panel.self_modulate = Color.WHITE
	panel.add_theme_stylebox_override(
		"panel",
		_rounded_box(PANEL_VIOLET_DEEP, 0, 10, Color(GOLD.r, GOLD.g, GOLD.b, 0.35), 0)
	)
	# Top gold rule via border
	var style := panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style.border_width_top = 2
	style.border_color = GOLD
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", style)


static func apply_body_label(label: Label, muted: bool = false, size: int = 20) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", TEXT_MUTED if muted else TEXT_LIGHT)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


static func apply_title_label(label: Label) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 40)
	label.add_theme_color_override("font_color", GOLD)


static func apply_section_label(label: Label) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", GOLD)


static func apply_eyebrow_label(label: Label) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", GOLD_DIM)


static func apply_line_edit(edit: LineEdit) -> void:
	if edit == null:
		return
	edit.custom_minimum_size = Vector2(0, 56)
	edit.add_theme_font_size_override("font_size", 22)
	var style := _rounded_box(NAVY_DEEP, 12, 12, Color(GOLD.r, GOLD.g, GOLD.b, 0.4), 1)
	edit.add_theme_stylebox_override("normal", style)
	edit.add_theme_stylebox_override("focus", _rounded_box(NAVY_DEEP, 12, 12, GOLD, 2))
	edit.add_theme_color_override("font_color", TEXT_LIGHT)
	edit.add_theme_color_override("font_placeholder_color", TEXT_MUTED)


static func apply_option_button(option: OptionButton) -> void:
	if option == null:
		return
	option.custom_minimum_size = Vector2(0, 56)
	option.add_theme_font_size_override("font_size", 20)
	option.add_theme_stylebox_override(
		"normal",
		_rounded_box(NAVY_DEEP, 12, 12, Color(GOLD.r, GOLD.g, GOLD.b, 0.4), 1)
	)
	option.add_theme_color_override("font_color", TEXT_LIGHT)

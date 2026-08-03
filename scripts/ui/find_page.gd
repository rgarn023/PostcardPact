extends Control
## Prototype match listings from local JSON sample data.

@onready var _header_label: Label = %FindHeader
@onready var _disclaimer_label: Label = %FindDisclaimer
@onready var _list: VBoxContainer = %FindList


func _ready() -> void:
	UiStyle.apply_section_label(_header_label)
	UiStyle.apply_body_label(_disclaimer_label, true, 16)
	_header_label.text = "Find"
	_disclaimer_label.text = (
		"Prototype matches — local sample data using the official 18 habitats. "
		+ "Not real people. No personal information is revealed."
	)
	_rebuild_cards()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible and _list.get_child_count() == 0:
		_rebuild_cards()


func _rebuild_cards() -> void:
	for child in _list.get_children():
		child.queue_free()

	for match_profile: MatchProfile in AppData.sample_matches:
		_list.add_child(_make_card(match_profile))


func _make_card(match_profile: MatchProfile) -> PanelContainer:
	var panel := PanelContainer.new()
	UiStyle.apply_panel(panel, true)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	box.add_child(top)

	var badge := Label.new()
	badge.text = "PROTOTYPE MATCH"
	UiStyle.apply_eyebrow_label(badge)
	badge.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(badge)

	var name_label := Label.new()
	name_label.text = match_profile.display_name
	name_label.add_theme_font_size_override("font_size", 26)
	name_label.add_theme_color_override("font_color", UiStyle.TEXT_LIGHT)
	box.add_child(name_label)

	var metrics := HBoxContainer.new()
	metrics.add_theme_constant_override("separation", 8)
	box.add_child(metrics)
	metrics.add_child(_metric_chip("Offers", match_profile.primary_offered_region()))
	metrics.add_child(_metric_chip("Needs", match_profile.primary_needed_region()))

	box.add_child(_info_label("Interaction: %s" % match_profile.interaction_frequency))
	return panel


func _metric_chip(title: String, value: String) -> PanelContainer:
	var panel := PanelContainer.new()
	UiStyle.apply_metric_panel(panel)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	panel.add_child(box)

	var title_label := Label.new()
	title_label.text = title
	UiStyle.apply_eyebrow_label(title_label)
	box.add_child(title_label)

	var value_label := Label.new()
	value_label.text = value
	UiStyle.apply_body_label(value_label, false, 18)
	value_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(value_label)
	return panel


func _info_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	UiStyle.apply_body_label(label, true, 17)
	return label

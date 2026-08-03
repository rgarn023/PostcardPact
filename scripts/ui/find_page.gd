extends Control
## Prototype match listings from local JSON sample data.

@onready var _header_label: Label = %FindHeader
@onready var _disclaimer_label: Label = %FindDisclaimer
@onready var _list: VBoxContainer = %FindList


func _ready() -> void:
	UiStyle.apply_title_label(_header_label)
	UiStyle.apply_body_label(_disclaimer_label, true)
	_header_label.text = "Find"
	_disclaimer_label.text = (
		"Prototype matches only — local sample data, not real people. "
		+ "No personal information is revealed."
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
	UiStyle.apply_panel(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var badge := Label.new()
	badge.text = "Prototype Match"
	badge.add_theme_font_size_override("font_size", 16)
	badge.add_theme_color_override("font_color", UiStyle.GOLD)
	box.add_child(badge)

	var name_label := Label.new()
	name_label.text = match_profile.display_name
	name_label.add_theme_font_size_override("font_size", 24)
	name_label.add_theme_color_override("font_color", UiStyle.TEXT_LIGHT)
	box.add_child(name_label)

	box.add_child(_info_label("Offered region: %s" % match_profile.primary_offered_region()))
	box.add_child(_info_label("Needed region: %s" % match_profile.primary_needed_region()))
	box.add_child(_info_label("Interaction preference: %s" % match_profile.interaction_frequency))

	return panel


func _info_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	UiStyle.apply_body_label(label, true)
	return label

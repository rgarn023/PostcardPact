extends Control
## Home summary page — postcard stamp hero + compact profile summary.

@onready var _hero_panel: PanelContainer = %HomeHeroPanel
@onready var _eyebrow_label: Label = %HomeEyebrow
@onready var _title_label: Label = %HomeTitle
@onready var _tagline_label: Label = %HomeTagline
@onready var _disclaimer_label: Label = %HomeDisclaimer
@onready var _display_name_label: Label = %HomeDisplayName
@onready var _region_label: Label = %HomeRegion
@onready var _needed_count_label: Label = %HomeNeededCount
@onready var _setup_button: Button = %HomeSetupButton
@onready var _summary_panel: PanelContainer = %HomeSummaryPanel
@onready var _region_metric_panel: PanelContainer = %HomeRegionMetric
@onready var _needed_metric_panel: PanelContainer = %HomeNeededMetric


func _ready() -> void:
	_apply_styles()
	if not _setup_button.pressed.is_connected(_on_setup_button_pressed):
		_setup_button.pressed.connect(_on_setup_button_pressed)
	if not AppData.profile_changed.is_connected(_on_profile_changed):
		AppData.profile_changed.connect(_on_profile_changed)
	_refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible:
		_refresh()


func _apply_styles() -> void:
	UiStyle.apply_hero_panel(_hero_panel)
	UiStyle.apply_eyebrow_label(_eyebrow_label)
	UiStyle.apply_title_label(_title_label)
	UiStyle.apply_body_label(_tagline_label, false, 20)
	UiStyle.apply_body_label(_disclaimer_label, true, 16)
	UiStyle.apply_body_label(_display_name_label, false, 22)
	UiStyle.apply_body_label(_region_label, false, 20)
	UiStyle.apply_body_label(_needed_count_label, false, 20)
	UiStyle.apply_panel(_summary_panel, true)
	UiStyle.apply_metric_panel(_region_metric_panel)
	UiStyle.apply_metric_panel(_needed_metric_panel)
	UiStyle.apply_primary_button(_setup_button)
	_eyebrow_label.text = "TRAVEL COMPANION"
	_title_label.text = "Postcard Pact"
	_tagline_label.text = "Find postcard partners across the 18 habitats."


func _on_profile_changed(_profile: UserProfile) -> void:
	_refresh()


func _refresh() -> void:
	_disclaimer_label.text = (
		"Independent companion app — never logs into Pokémon GO, never asks for passwords, "
		+ "and never automates gifts, friendship, or trades."
	)

	if AppData.has_saved_profile():
		var profile := AppData.profile
		_display_name_label.text = profile.display_name
		_region_label.text = profile.region
		_needed_count_label.text = "%d needed" % profile.needed_regions.size()
		_setup_button.visible = false
		_summary_panel.visible = true
	else:
		_display_name_label.text = "No local profile yet"
		_region_label.text = "—"
		_needed_count_label.text = "0 needed"
		_setup_button.visible = true
		_setup_button.text = "Set Up Profile"
		_summary_panel.visible = true


func _on_setup_button_pressed() -> void:
	var main := get_tree().current_scene
	if main is MobileNavigation:
		(main as MobileNavigation).go_to_page(MobileNavigation.Page.PROFILE)
	elif main != null and main.has_method("go_to_page_index"):
		main.go_to_page_index(4)
	else:
		push_warning("HomePage: Could not open Profile page through navigation.")

extends Control
## Manual friendship journey tracking (offline, user-reported).

@onready var _header_label: Label = %JourneyHeader
@onready var _partner_label: Label = %JourneyPartnerLabel
@onready var _disclaimer_label: Label = %JourneyDisclaimer
@onready var _interacted_check: CheckBox = %JourneyInteractedCheck
@onready var _gift_sent_check: CheckBox = %JourneyGiftSentCheck
@onready var _gift_opened_check: CheckBox = %JourneyGiftOpenedCheck
@onready var _committed_check: CheckBox = %JourneyCommittedCheck
@onready var _status_label: Label = %JourneyStatusLabel
@onready var _panel: PanelContainer = %JourneyPanel

var _suppress_save: bool = false


func _ready() -> void:
	_apply_styles()
	_wire_signals()
	if not AppData.journey_changed.is_connected(_on_journey_changed):
		AppData.journey_changed.connect(_on_journey_changed)
	_load_from_data(AppData.journey)


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible:
		_load_from_data(AppData.journey)


func _apply_styles() -> void:
	UiStyle.apply_title_label(_header_label)
	UiStyle.apply_body_label(_partner_label)
	UiStyle.apply_body_label(_disclaimer_label, true)
	UiStyle.apply_body_label(_status_label, true)
	UiStyle.apply_panel(_panel)
	_header_label.text = "Journey"
	_disclaimer_label.text = (
		"User-reported prototype journey. Progress is entered manually and is never "
		+ "read from Pokémon GO."
	)
	for check in [
		_interacted_check, _gift_sent_check, _gift_opened_check, _committed_check
	]:
		check.add_theme_font_size_override("font_size", 18)
		check.add_theme_color_override("font_color", UiStyle.TEXT_LIGHT)


func _wire_signals() -> void:
	_connect_check(_interacted_check)
	_connect_check(_gift_sent_check)
	_connect_check(_gift_opened_check)
	_connect_check(_committed_check)


func _connect_check(check: CheckBox) -> void:
	if check != null and not check.toggled.is_connected(_on_check_toggled):
		check.toggled.connect(_on_check_toggled)


func _on_journey_changed(journey: FriendshipJourney) -> void:
	if visible:
		_load_from_data(journey)


func _load_from_data(journey: FriendshipJourney) -> void:
	if journey == null:
		journey = FriendshipJourney.new()

	_suppress_save = true
	_partner_label.text = "Partner (sample): %s" % journey.partner_display_name
	_interacted_check.button_pressed = journey.interacted_today
	_gift_sent_check.button_pressed = journey.gift_sent_today
	_gift_opened_check.button_pressed = journey.gift_opened_today
	_committed_check.button_pressed = journey.still_committed_to_future_trade
	_status_label.text = "Changes save automatically on this device."
	_suppress_save = false


func _on_check_toggled(_pressed: bool) -> void:
	if _suppress_save:
		return

	var updated := FriendshipJourney.from_dictionary(AppData.journey.to_dictionary())
	updated.interacted_today = _interacted_check.button_pressed
	updated.gift_sent_today = _gift_sent_check.button_pressed
	updated.gift_opened_today = _gift_opened_check.button_pressed
	updated.still_committed_to_future_trade = _committed_check.button_pressed

	if AppData.save_journey(updated):
		_status_label.add_theme_color_override("font_color", UiStyle.SUCCESS)
		_status_label.text = "Journey progress saved locally."
	else:
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = "Could not save journey progress."

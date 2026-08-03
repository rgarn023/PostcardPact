extends Control
## Offline prototype trade request form. Never performs or guarantees trades.

@onready var _header_label: Label = %TradesHeader
@onready var _disclaimer_label: Label = %TradesDisclaimer
@onready var _wanted_edit: LineEdit = %WantedCreatureEdit
@onready var _offered_edit: LineEdit = %OfferedCreatureEdit
@onready var _save_button: Button = %SaveTradeButton
@onready var _status_label: Label = %TradeStatusLabel
@onready var _panel: PanelContainer = %TradesPanel


func _ready() -> void:
	_apply_styles()
	if not _save_button.pressed.is_connected(_on_save_pressed):
		_save_button.pressed.connect(_on_save_pressed)
	if not AppData.trade_changed.is_connected(_on_trade_changed):
		AppData.trade_changed.connect(_on_trade_changed)
	_load_from_data(AppData.trade)


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible:
		_load_from_data(AppData.trade)


func _apply_styles() -> void:
	UiStyle.apply_title_label(_header_label)
	UiStyle.apply_body_label(_disclaimer_label, true)
	UiStyle.apply_body_label(_status_label, true)
	UiStyle.apply_line_edit(_wanted_edit)
	UiStyle.apply_line_edit(_offered_edit)
	UiStyle.apply_primary_button(_save_button)
	UiStyle.apply_panel(_panel)
	_header_label.text = "Trades"
	_disclaimer_label.text = (
		"Prototype planning only. Postcard Pact does not guarantee, broker, automate, "
		+ "or perform trades. Never buy or sell accounts, creatures, gifts, or services."
	)
	_wanted_edit.placeholder_text = "Wanted creature (nickname / description)"
	_offered_edit.placeholder_text = "Offered creature (nickname / description)"


func _on_trade_changed(trade: TradeRequest) -> void:
	if visible:
		_load_from_data(trade)


func _load_from_data(trade: TradeRequest) -> void:
	if trade == null:
		trade = TradeRequest.new()
	_wanted_edit.text = trade.wanted_text()
	_offered_edit.text = trade.offered_text()
	if trade.request_id.is_empty():
		_status_label.text = "Draft a future trade idea for your own notes."
	else:
		_status_label.text = "Saved offline request: %s" % trade.request_id


func _on_save_pressed() -> void:
	var wanted := _wanted_edit.text.strip_edges()
	var offered := _offered_edit.text.strip_edges()

	if wanted.is_empty() and offered.is_empty():
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = "Enter at least one wanted or offered creature."
		return

	var updated := TradeRequest.from_dictionary(AppData.trade.to_dictionary())
	updated.wanted_creatures = PackedStringArray([wanted] if not wanted.is_empty() else [])
	updated.offered_creatures = PackedStringArray([offered] if not offered.is_empty() else [])

	if AppData.save_trade(updated):
		_status_label.add_theme_color_override("font_color", UiStyle.SUCCESS)
		_status_label.text = "Trade request saved locally. No trade was performed."
	else:
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = "Could not save trade request."

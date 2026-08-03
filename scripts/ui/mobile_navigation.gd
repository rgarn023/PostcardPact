extends Control
## Bottom-navigation controller for the Postcard Pact offline prototype.
## Attach this script to the root Main (Control) node of res://scenes/main/Main.tscn.

enum Page {
	HOME,
	FIND,
	JOURNEY,
	TRADES,
	PROFILE,
}

const PAGE_NAMES: Dictionary = {
	Page.HOME: "Home",
	Page.FIND: "Find",
	Page.JOURNEY: "Journey",
	Page.TRADES: "Trades",
	Page.PROFILE: "Profile",
}

signal page_changed(page_name: String)

var _current_page: Page = Page.HOME
var _pages: Dictionary = {}
var _nav_buttons: Dictionary = {}
var _is_ready: bool = false


func _ready() -> void:
	if not _resolve_nodes():
		push_error("MobileNavigation: Required nodes are missing. Navigation disabled.")
		return

	_is_ready = true
	_show_page(Page.HOME)


func get_current_page_name() -> String:
	return PAGE_NAMES.get(_current_page, "Unknown")


func go_to_page(page: Page) -> void:
	if not _is_ready:
		push_warning("MobileNavigation: Ignoring page change before initialization.")
		return
	_show_page(page)


func _on_home_button_pressed() -> void:
	_show_page(Page.HOME)


func _on_find_button_pressed() -> void:
	_show_page(Page.FIND)


func _on_journey_button_pressed() -> void:
	_show_page(Page.JOURNEY)


func _on_trades_button_pressed() -> void:
	_show_page(Page.TRADES)


func _on_profile_button_pressed() -> void:
	_show_page(Page.PROFILE)


func _resolve_nodes() -> bool:
	var missing: PackedStringArray = PackedStringArray()

	_pages = {
		Page.HOME: _get_required_control("%HomePage", missing),
		Page.FIND: _get_required_control("%FindPage", missing),
		Page.JOURNEY: _get_required_control("%JourneyPage", missing),
		Page.TRADES: _get_required_control("%TradesPage", missing),
		Page.PROFILE: _get_required_control("%ProfilePage", missing),
	}

	_nav_buttons = {
		Page.HOME: _get_required_button("%HomeButton", missing),
		Page.FIND: _get_required_button("%FindButton", missing),
		Page.JOURNEY: _get_required_button("%JourneyButton", missing),
		Page.TRADES: _get_required_button("%TradesButton", missing),
		Page.PROFILE: _get_required_button("%ProfileButton", missing),
	}

	if not missing.is_empty():
		for node_name: String in missing:
			push_error("MobileNavigation: Missing required node '%s'." % node_name)
		return false

	return true


func _get_required_control(unique_name: String, missing: PackedStringArray) -> Control:
	var node: Node = get_node_or_null(unique_name)
	if node == null or not (node is Control):
		missing.append(unique_name)
		return null
	return node as Control


func _get_required_button(unique_name: String, missing: PackedStringArray) -> Button:
	var node: Node = get_node_or_null(unique_name)
	if node == null or not (node is Button):
		missing.append(unique_name)
		return null
	return node as Button


func _show_page(page: Page) -> void:
	if not _pages.has(page):
		push_error("MobileNavigation: Unknown page '%s'." % str(page))
		return

	for page_key: Variant in _pages.keys():
		var page_node: Control = _pages[page_key] as Control
		if page_node == null:
			continue
		page_node.visible = (page_key == page)

	_current_page = page
	_update_nav_button_states(page)
	page_changed.emit(PAGE_NAMES[page])


func _update_nav_button_states(active_page: Page) -> void:
	# Soft golden highlight for the active tab; no toggle_mode required.
	var active_color := Color(1.0, 0.84, 0.4, 1.0)
	var idle_color := Color(1.0, 1.0, 1.0, 1.0)

	for page_key: Variant in _nav_buttons.keys():
		var button: Button = _nav_buttons[page_key] as Button
		if button == null:
			continue
		button.modulate = active_color if page_key == active_page else idle_color

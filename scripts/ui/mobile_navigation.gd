extends Control
## Bottom-navigation controller for the Postcard Pact offline prototype.
## Attach this script to the root Main (Control) node of res://scenes/main/Main.tscn.
##
## Expected unique-name nodes:
##   Pages:   HomePage, FindPage, JourneyPage, TradesPage, ProfilePage (Control)
##   Buttons: HomeButton, FindButton, JourneyButton, TradesButton, ProfileButton (Button)

enum Page {
	HOME = 0,
	FIND = 1,
	JOURNEY = 2,
	TRADES = 3,
	PROFILE = 4,
}

const PAGE_COUNT: int = 5

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
	return str(PAGE_NAMES.get(_current_page, "Unknown"))


func get_current_page() -> Page:
	return _current_page


func go_to_page(page: Page) -> void:
	if not _is_ready:
		push_warning("MobileNavigation: Ignoring page change before initialization.")
		return

	if not _is_valid_page(page):
		push_warning(
			"MobileNavigation: Page index %d is out of bounds (valid: 0..%d)."
			% [int(page), PAGE_COUNT - 1]
		)
		return

	_show_page(page)


func go_to_page_index(page_index: int) -> void:
	if page_index < 0 or page_index >= PAGE_COUNT:
		push_warning(
			"MobileNavigation: Page index %d is out of bounds (valid: 0..%d)."
			% [page_index, PAGE_COUNT - 1]
		)
		return
	go_to_page(page_index as Page)


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


func _is_valid_page(page: Page) -> bool:
	var page_index: int = int(page)
	return page_index >= 0 and page_index < PAGE_COUNT and PAGE_NAMES.has(page)


func _resolve_nodes() -> bool:
	var missing: PackedStringArray = PackedStringArray()

	_pages = {
		Page.HOME: _get_required_control("HomePage", missing),
		Page.FIND: _get_required_control("FindPage", missing),
		Page.JOURNEY: _get_required_control("JourneyPage", missing),
		Page.TRADES: _get_required_control("TradesPage", missing),
		Page.PROFILE: _get_required_control("ProfilePage", missing),
	}

	_nav_buttons = {
		Page.HOME: _get_required_button("HomeButton", missing),
		Page.FIND: _get_required_button("FindButton", missing),
		Page.JOURNEY: _get_required_button("JourneyButton", missing),
		Page.TRADES: _get_required_button("TradesButton", missing),
		Page.PROFILE: _get_required_button("ProfileButton", missing),
	}

	if not missing.is_empty():
		for node_name: String in missing:
			push_error("MobileNavigation: Missing required node '%s'." % node_name)
		return false

	return true


func _get_required_control(node_name: String, missing: PackedStringArray) -> Control:
	var node: Node = get_node_or_null("%" + node_name)
	if node == null:
		push_warning("MobileNavigation: Control '%s' not found (unique name required)." % node_name)
		missing.append(node_name)
		return null
	if not (node is Control):
		push_warning(
			"MobileNavigation: Node '%s' must be Control, found '%s'."
			% [node_name, node.get_class()]
		)
		missing.append(node_name)
		return null
	return node as Control


func _get_required_button(node_name: String, missing: PackedStringArray) -> Button:
	var node: Node = get_node_or_null("%" + node_name)
	if node == null:
		push_warning("MobileNavigation: Button '%s' not found (unique name required)." % node_name)
		missing.append(node_name)
		return null
	if not (node is Button):
		push_warning(
			"MobileNavigation: Node '%s' must be Button, found '%s'."
			% [node_name, node.get_class()]
		)
		missing.append(node_name)
		return null
	return node as Button


func _show_page(page: Page) -> void:
	if not _is_valid_page(page):
		push_warning(
			"MobileNavigation: Cannot show page index %d (out of bounds 0..%d)."
			% [int(page), PAGE_COUNT - 1]
		)
		return

	if not _pages.has(page):
		push_error("MobileNavigation: Page '%s' was not resolved." % PAGE_NAMES.get(page, str(page)))
		return

	for page_key: Variant in _pages.keys():
		var page_node: Control = _pages[page_key] as Control
		if page_node == null:
			push_warning("MobileNavigation: Skipping null page for key '%s'." % str(page_key))
			continue
		page_node.visible = (page_key == page)

	_current_page = page
	_update_nav_button_states(page)

	var page_name: String = str(PAGE_NAMES[page])
	page_changed.emit(page_name)


func _update_nav_button_states(active_page: Page) -> void:
	for page_key: Variant in _nav_buttons.keys():
		var button: Button = _nav_buttons[page_key] as Button
		if button == null:
			push_warning("MobileNavigation: Skipping null nav button for key '%s'." % str(page_key))
			continue
		# Disable only the button for the currently selected page.
		button.disabled = (page_key == active_page)

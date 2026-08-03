extends Control
## Offline profile editor with official 18-habitat region selection.

@onready var _header_label: Label = %ProfileHeader
@onready var _hint_label: Label = %ProfileHint
@onready var _display_name_edit: LineEdit = %DisplayNameEdit
@onready var _trainer_code_edit: LineEdit = %TrainerCodeEdit
@onready var _region_option: OptionButton = %RegionOption
@onready var _needed_list: GridContainer = %NeededRegionsList
@onready var _save_button: Button = %SaveProfileButton
@onready var _reset_button: Button = %ResetProfileButton
@onready var _status_label: Label = %ProfileStatusLabel

var _needed_checks: Dictionary = {}


func _ready() -> void:
	_apply_styles()
	_populate_regions()
	_wire_signals()
	if not AppData.profile_changed.is_connected(_on_profile_changed):
		AppData.profile_changed.connect(_on_profile_changed)
	_load_into_form(AppData.profile)


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and visible:
		_load_into_form(AppData.profile)


func _apply_styles() -> void:
	UiStyle.apply_section_label(_header_label)
	UiStyle.apply_body_label(_hint_label, true, 17)
	UiStyle.apply_line_edit(_display_name_edit)
	UiStyle.apply_line_edit(_trainer_code_edit)
	UiStyle.apply_option_button(_region_option)
	UiStyle.apply_primary_button(_save_button)
	UiStyle.apply_secondary_button(_reset_button)
	UiStyle.apply_body_label(_status_label, true, 17)
	_header_label.text = "Profile"
	_display_name_edit.placeholder_text = "Display name"
	_trainer_code_edit.placeholder_text = "Trainer code (numbers and spaces)"
	_hint_label.text = (
		"Saved only on this device. Choose from the official 18 postcard habitats. "
		+ "Never enter a Pokémon GO password."
	)
	_status_label.text = "Trainer codes stay on this device."


func _wire_signals() -> void:
	if not _save_button.pressed.is_connected(_on_save_pressed):
		_save_button.pressed.connect(_on_save_pressed)
	if not _reset_button.pressed.is_connected(_on_reset_pressed):
		_reset_button.pressed.connect(_on_reset_pressed)


func _populate_regions() -> void:
	_region_option.clear()
	_region_option.add_item("Select your postcard habitat")
	_region_option.set_item_disabled(0, true)

	for region_name: String in AppData.regions:
		_region_option.add_item(region_name)

	for child in _needed_list.get_children():
		child.queue_free()
	_needed_checks.clear()
	_needed_list.columns = 2

	for region_name: String in AppData.regions:
		var check := CheckBox.new()
		check.text = region_name
		check.add_theme_font_size_override("font_size", 17)
		check.add_theme_color_override("font_color", UiStyle.TEXT_LIGHT)
		check.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_needed_list.add_child(check)
		_needed_checks[region_name] = check


func _on_profile_changed(profile: UserProfile) -> void:
	if visible:
		_load_into_form(profile)


func _load_into_form(profile: UserProfile) -> void:
	if profile == null:
		profile = UserProfile.new()

	_display_name_edit.text = profile.display_name
	_trainer_code_edit.text = profile.trainer_code

	var region_index := 0
	for i in range(_region_option.item_count):
		if _region_option.get_item_text(i) == profile.region:
			region_index = i
			break
	_region_option.select(region_index)

	var official_needed := RegionService.filter_to_official(profile.needed_regions)
	for region_name: Variant in _needed_checks.keys():
		var check: CheckBox = _needed_checks[region_name] as CheckBox
		if check != null:
			check.button_pressed = official_needed.has(str(region_name))

	if not profile.region.is_empty() and not RegionService.is_official_region(profile.region):
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = (
			"Saved region '%s' is outdated. Please select an official habitat and save."
			% profile.region
		)


func _on_save_pressed() -> void:
	var display_name := _display_name_edit.text.strip_edges()
	var trainer_code := _trainer_code_edit.text.strip_edges()
	var selected_region := ""
	if _region_option.selected > 0:
		selected_region = _region_option.get_item_text(_region_option.selected)

	var validation_error := _validate(display_name, trainer_code, selected_region)
	if not validation_error.is_empty():
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = validation_error
		return

	var updated := AppData.profile if AppData.profile != null else UserProfile.new()
	updated = UserProfile.from_dictionary(updated.to_dictionary())
	updated.display_name = display_name
	updated.trainer_code = trainer_code
	updated.region = selected_region
	updated.offered_regions = PackedStringArray([selected_region])
	updated.needed_regions = _collect_needed_regions()

	if AppData.save_profile(updated):
		_status_label.add_theme_color_override("font_color", UiStyle.SUCCESS)
		_status_label.text = "Profile saved on this device."
	else:
		_status_label.add_theme_color_override("font_color", UiStyle.DANGER)
		_status_label.text = "Could not save profile. Check region selection and storage."


func _on_reset_pressed() -> void:
	AppData.reset_profile()
	_load_into_form(AppData.profile)
	_status_label.add_theme_color_override("font_color", UiStyle.TEXT_MUTED)
	_status_label.text = "Local test profile cleared."


func _collect_needed_regions() -> PackedStringArray:
	var selected := PackedStringArray()
	for region_name: Variant in _needed_checks.keys():
		var check: CheckBox = _needed_checks[region_name] as CheckBox
		if check != null and check.button_pressed:
			selected.append(str(region_name))
	return RegionService.filter_to_official(selected)


func _validate(display_name: String, trainer_code: String, region: String) -> String:
	if display_name.is_empty():
		return "Display name cannot be blank."
	if trainer_code.is_empty():
		return "Trainer code cannot be blank."
	if not _is_valid_trainer_code(trainer_code):
		return "Trainer code may contain numbers and spaces only."
	if region.is_empty() or region.begins_with("Select "):
		return "Please select your postcard habitat."
	if not RegionService.is_official_region(region):
		return "Please choose one of the official 18 postcard habitats."
	return ""


func _is_valid_trainer_code(value: String) -> bool:
	for i in value.length():
		var ch := value.unicode_at(i)
		var is_digit := ch >= 48 and ch <= 57
		var is_space := ch == 32
		if not is_digit and not is_space:
			return false
	return value.replace(" ", "").length() > 0

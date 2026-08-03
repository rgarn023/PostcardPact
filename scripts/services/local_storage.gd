class_name LocalStorage
extends RefCounted
## JSON helpers for offline user:// persistence.

const PROFILE_PATH := "user://profile.json"
const JOURNEY_PATH := "user://journey.json"
const TRADE_PATH := "user://trade_request.json"


static func read_dictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("LocalStorage: Could not open '%s' for reading (error %s)." % [
			path, str(FileAccess.get_open_error())
		])
		return {}

	var text := file.get_as_text()
	file.close()
	if text.strip_edges().is_empty():
		return {}

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("LocalStorage: Malformed JSON in '%s'. Ignoring saved data." % path)
		return {}
	return parsed


static func write_dictionary(path: String, data: Dictionary) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("LocalStorage: Could not open '%s' for writing (error %s)." % [
			path, str(FileAccess.get_open_error())
		])
		return false

	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true


static func delete_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		return

	var dir := DirAccess.open("user://")
	if dir == null:
		push_warning("LocalStorage: Could not open user:// to delete '%s'." % path)
		return

	var err := dir.remove(path.get_file())
	if err != OK:
		push_warning("LocalStorage: Failed to delete '%s' (error %s)." % [path, str(err)])


static func load_res_dictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("LocalStorage: Missing resource file '%s'." % path)
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("LocalStorage: Could not read resource '%s'." % path)
		return {}

	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("LocalStorage: Invalid JSON resource '%s'." % path)
		return {}
	return parsed


static func utc_timestamp() -> String:
	return Time.get_datetime_string_from_system(true)

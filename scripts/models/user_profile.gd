class_name UserProfile
extends RefCounted
## Local offline user profile. Never stores game passwords or precise GPS.

var local_user_id: String = ""
var display_name: String = ""
var trainer_code: String = ""
var country: String = ""
var region: String = ""
var languages: PackedStringArray = PackedStringArray()
var interaction_frequency: String = "Daily"
var available_to_send: bool = true
var needed_regions: PackedStringArray = PackedStringArray()
var offered_regions: PackedStringArray = PackedStringArray()
var wanted_creatures: PackedStringArray = PackedStringArray()
var offered_creatures: PackedStringArray = PackedStringArray()
var profile_created_at: String = ""
var profile_updated_at: String = ""


func is_complete() -> bool:
	return not display_name.strip_edges().is_empty() \
		and not trainer_code.strip_edges().is_empty() \
		and not region.strip_edges().is_empty()


func to_dictionary() -> Dictionary:
	return {
		"local_user_id": local_user_id,
		"display_name": display_name,
		"trainer_code": trainer_code,
		"country": country,
		"region": region,
		"languages": Array(languages),
		"interaction_frequency": interaction_frequency,
		"available_to_send": available_to_send,
		"needed_regions": Array(needed_regions),
		"offered_regions": Array(offered_regions),
		"wanted_creatures": Array(wanted_creatures),
		"offered_creatures": Array(offered_creatures),
		"profile_created_at": profile_created_at,
		"profile_updated_at": profile_updated_at,
	}


static func from_dictionary(data: Dictionary) -> UserProfile:
	var profile := UserProfile.new()
	if data.is_empty():
		return profile

	profile.local_user_id = str(data.get("local_user_id", ""))
	profile.display_name = str(data.get("display_name", ""))
	profile.trainer_code = str(data.get("trainer_code", ""))
	profile.country = str(data.get("country", ""))
	profile.region = str(data.get("region", ""))
	profile.languages = _to_packed_strings(data.get("languages", []))
	profile.interaction_frequency = str(data.get("interaction_frequency", "Daily"))
	profile.available_to_send = bool(data.get("available_to_send", true))
	profile.needed_regions = _to_packed_strings(data.get("needed_regions", []))
	profile.offered_regions = _to_packed_strings(data.get("offered_regions", []))
	profile.wanted_creatures = _to_packed_strings(data.get("wanted_creatures", []))
	profile.offered_creatures = _to_packed_strings(data.get("offered_creatures", []))
	profile.profile_created_at = str(data.get("profile_created_at", ""))
	profile.profile_updated_at = str(data.get("profile_updated_at", ""))
	return profile


static func _to_packed_strings(value: Variant) -> PackedStringArray:
	var result := PackedStringArray()
	if value is PackedStringArray:
		return value
	if value is Array:
		for item: Variant in value:
			result.append(str(item))
	elif value is String and not str(value).is_empty():
		result.append(str(value))
	return result

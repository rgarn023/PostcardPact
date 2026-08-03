class_name MatchProfile
extends RefCounted
## Prototype match card data loaded from local JSON test files.

var profile_id: String = ""
var display_name: String = ""
var country: String = ""
var region: String = ""
var offered_regions: PackedStringArray = PackedStringArray()
var needed_regions: PackedStringArray = PackedStringArray()
var wanted_creatures: PackedStringArray = PackedStringArray()
var offered_creatures: PackedStringArray = PackedStringArray()
var interaction_frequency: String = ""
var available_to_send: bool = false
var last_active: String = ""
var is_blocked: bool = false


static func from_dictionary(data: Dictionary) -> MatchProfile:
	var profile := MatchProfile.new()
	if data.is_empty():
		return profile

	profile.profile_id = str(data.get("profile_id", ""))
	profile.display_name = str(data.get("display_name", "Sample Traveler"))
	profile.country = str(data.get("country", ""))
	profile.region = str(data.get("region", ""))
	profile.offered_regions = UserProfile._to_packed_strings(data.get("offered_regions", []))
	profile.needed_regions = UserProfile._to_packed_strings(data.get("needed_regions", []))
	profile.wanted_creatures = UserProfile._to_packed_strings(data.get("wanted_creatures", []))
	profile.offered_creatures = UserProfile._to_packed_strings(data.get("offered_creatures", []))
	profile.interaction_frequency = str(data.get("interaction_frequency", "Unknown"))
	profile.available_to_send = bool(data.get("available_to_send", false))
	profile.last_active = str(data.get("last_active", "Prototype data"))
	profile.is_blocked = bool(data.get("is_blocked", false))
	return profile


func primary_offered_region() -> String:
	if offered_regions.size() > 0:
		return offered_regions[0]
	return region if not region.is_empty() else "Unknown region"


func primary_needed_region() -> String:
	if needed_regions.size() > 0:
		return needed_regions[0]
	return "Any region"

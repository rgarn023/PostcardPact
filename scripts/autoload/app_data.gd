extends Node
## Offline application data store. Autoload name: AppData

signal profile_changed(profile: UserProfile)
signal journey_changed(journey: FriendshipJourney)
signal trade_changed(trade: TradeRequest)

const REGIONS_PATH := "res://data/regions.json"
const SAMPLE_PROFILES_PATH := "res://data/sample_profiles.json"

var profile: UserProfile = UserProfile.new()
var journey: FriendshipJourney = FriendshipJourney.new()
var trade: TradeRequest = TradeRequest.new()
var regions: PackedStringArray = PackedStringArray()
var sample_matches: Array[MatchProfile] = []


func _ready() -> void:
	_load_regions()
	_load_sample_matches()
	reload_from_disk()


func has_saved_profile() -> bool:
	return profile != null and profile.is_complete()


func reload_from_disk() -> void:
	profile = UserProfile.from_dictionary(LocalStorage.read_dictionary(LocalStorage.PROFILE_PATH))
	var journey_data := LocalStorage.read_dictionary(LocalStorage.JOURNEY_PATH)
	if journey_data.is_empty():
		journey = FriendshipJourney.new()
	else:
		journey = FriendshipJourney.from_dictionary(journey_data)

	var trade_data := LocalStorage.read_dictionary(LocalStorage.TRADE_PATH)
	if trade_data.is_empty():
		trade = TradeRequest.new()
	else:
		trade = TradeRequest.from_dictionary(trade_data)

	profile_changed.emit(profile)
	journey_changed.emit(journey)
	trade_changed.emit(trade)


func save_profile(updated: UserProfile) -> bool:
	if updated == null:
		push_error("AppData: Cannot save a null profile.")
		return false

	var now := LocalStorage.utc_timestamp()
	if updated.local_user_id.strip_edges().is_empty():
		updated.local_user_id = "local_%s" % str(Time.get_unix_time_from_system()).replace(".", "")
	if updated.profile_created_at.strip_edges().is_empty():
		updated.profile_created_at = now
	updated.profile_updated_at = now

	if not LocalStorage.write_dictionary(LocalStorage.PROFILE_PATH, updated.to_dictionary()):
		return false

	profile = updated
	profile_changed.emit(profile)
	return true


func reset_profile() -> void:
	LocalStorage.delete_file(LocalStorage.PROFILE_PATH)
	profile = UserProfile.new()
	profile_changed.emit(profile)


func save_journey(updated: FriendshipJourney) -> bool:
	if updated == null:
		push_error("AppData: Cannot save a null journey.")
		return false

	updated.last_interaction_date = LocalStorage.utc_timestamp()
	if not LocalStorage.write_dictionary(LocalStorage.JOURNEY_PATH, updated.to_dictionary()):
		return false

	journey = updated
	journey_changed.emit(journey)
	return true


func save_trade(updated: TradeRequest) -> bool:
	if updated == null:
		push_error("AppData: Cannot save a null trade request.")
		return false

	if updated.request_id.strip_edges().is_empty():
		updated.request_id = "trade_%s" % str(Time.get_unix_time_from_system()).replace(".", "")
	updated.last_updated = LocalStorage.utc_timestamp()
	updated.trade_status = "saved_offline"

	if not LocalStorage.write_dictionary(LocalStorage.TRADE_PATH, updated.to_dictionary()):
		return false

	trade = updated
	trade_changed.emit(trade)
	return true


func _load_regions() -> void:
	regions = PackedStringArray()
	var data := LocalStorage.load_res_dictionary(REGIONS_PATH)
	var list: Variant = data.get("regions", [])
	if list is Array:
		for item: Variant in list:
			var region_name := str(item).strip_edges()
			if not region_name.is_empty():
				regions.append(region_name)

	if regions.is_empty():
		push_warning("AppData: No regions loaded; using fallback list.")
		regions = PackedStringArray([
			"North America East",
			"North America West",
			"Western Mediterranean",
			"Japanese Archipelago",
			"Oceania",
		])


func _load_sample_matches() -> void:
	sample_matches.clear()
	var data := LocalStorage.load_res_dictionary(SAMPLE_PROFILES_PATH)
	var list: Variant = data.get("profiles", [])
	if list is Array:
		for item: Variant in list:
			if item is Dictionary:
				var match_profile := MatchProfile.from_dictionary(item)
				if not match_profile.is_blocked:
					sample_matches.append(match_profile)

	if sample_matches.is_empty():
		push_warning("AppData: No sample profiles loaded.")

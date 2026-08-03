class_name TradeRequest
extends RefCounted
## Offline prototype trade request. This app never performs or guarantees trades.

var request_id: String = ""
var partner_profile_id: String = "sample_local"
var wanted_creatures: PackedStringArray = PackedStringArray()
var offered_creatures: PackedStringArray = PackedStringArray()
var accepted_creature: String = ""
var trade_status: String = "draft"
var remote_trade_ready: bool = false
var last_updated: String = ""


func to_dictionary() -> Dictionary:
	return {
		"request_id": request_id,
		"partner_profile_id": partner_profile_id,
		"wanted_creatures": Array(wanted_creatures),
		"offered_creatures": Array(offered_creatures),
		"accepted_creature": accepted_creature,
		"trade_status": trade_status,
		"remote_trade_ready": remote_trade_ready,
		"last_updated": last_updated,
	}


static func from_dictionary(data: Dictionary) -> TradeRequest:
	var request := TradeRequest.new()
	if data.is_empty():
		return request

	request.request_id = str(data.get("request_id", ""))
	request.partner_profile_id = str(data.get("partner_profile_id", "sample_local"))
	request.wanted_creatures = UserProfile._to_packed_strings(data.get("wanted_creatures", []))
	request.offered_creatures = UserProfile._to_packed_strings(data.get("offered_creatures", []))
	request.accepted_creature = str(data.get("accepted_creature", ""))
	request.trade_status = str(data.get("trade_status", "draft"))
	request.remote_trade_ready = bool(data.get("remote_trade_ready", false))
	request.last_updated = str(data.get("last_updated", ""))
	return request


func wanted_text() -> String:
	return ", ".join(wanted_creatures) if wanted_creatures.size() > 0 else ""


func offered_text() -> String:
	return ", ".join(offered_creatures) if offered_creatures.size() > 0 else ""

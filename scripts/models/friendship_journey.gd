class_name FriendshipJourney
extends RefCounted
## Manually tracked friendship progress. All values are user-entered offline.

var journey_id: String = "sample_journey_001"
var partner_profile_id: String = "sample_002"
var partner_display_name: String = "Maple Route"
var current_stage: String = "Prototype friendship"
var estimated_progress: int = 0
var last_interaction_date: String = ""
var interacted_today: bool = false
var gift_sent_today: bool = false
var gift_opened_today: bool = false
var requested_creature: String = "Forest walker"
var promised_creature: String = "Trail marker"
var remote_trade_ready: bool = false
var trade_completed: bool = false
var notes: String = "User-reported prototype journey. Not connected to any game."
var still_committed_to_future_trade: bool = false


func to_dictionary() -> Dictionary:
	return {
		"journey_id": journey_id,
		"partner_profile_id": partner_profile_id,
		"partner_display_name": partner_display_name,
		"current_stage": current_stage,
		"estimated_progress": estimated_progress,
		"last_interaction_date": last_interaction_date,
		"interacted_today": interacted_today,
		"gift_sent_today": gift_sent_today,
		"gift_opened_today": gift_opened_today,
		"requested_creature": requested_creature,
		"promised_creature": promised_creature,
		"remote_trade_ready": remote_trade_ready,
		"trade_completed": trade_completed,
		"notes": notes,
		"still_committed_to_future_trade": still_committed_to_future_trade,
	}


static func from_dictionary(data: Dictionary) -> FriendshipJourney:
	var journey := FriendshipJourney.new()
	if data.is_empty():
		return journey

	journey.journey_id = str(data.get("journey_id", journey.journey_id))
	journey.partner_profile_id = str(data.get("partner_profile_id", journey.partner_profile_id))
	journey.partner_display_name = str(data.get("partner_display_name", journey.partner_display_name))
	journey.current_stage = str(data.get("current_stage", journey.current_stage))
	journey.estimated_progress = int(data.get("estimated_progress", 0))
	journey.last_interaction_date = str(data.get("last_interaction_date", ""))
	journey.interacted_today = bool(data.get("interacted_today", false))
	journey.gift_sent_today = bool(data.get("gift_sent_today", false))
	journey.gift_opened_today = bool(data.get("gift_opened_today", false))
	journey.requested_creature = str(data.get("requested_creature", journey.requested_creature))
	journey.promised_creature = str(data.get("promised_creature", journey.promised_creature))
	journey.remote_trade_ready = bool(data.get("remote_trade_ready", false))
	journey.trade_completed = bool(data.get("trade_completed", false))
	journey.notes = str(data.get("notes", journey.notes))
	journey.still_committed_to_future_trade = bool(
		data.get("still_committed_to_future_trade", false)
	)
	return journey

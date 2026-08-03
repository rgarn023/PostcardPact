class_name RegionService
extends RefCounted
## Loads the official 18 Pokémon GO postcard / Vivillon habitat names.

const REGIONS_PATH := "res://data/regions.json"

## Exact official habitat list (alphabetical). Fancy and Poké Ball are excluded.
const OFFICIAL_REGIONS: PackedStringArray = PackedStringArray([
	"Archipelago",
	"Continental",
	"Elegant",
	"Garden",
	"High Plains",
	"Icy Snow",
	"Jungle",
	"Marine",
	"Meadow",
	"Modern",
	"Monsoon",
	"Ocean",
	"Polar",
	"River",
	"Sandstorm",
	"Savanna",
	"Sun",
	"Tundra",
])


static func get_fallback_regions() -> PackedStringArray:
	return OFFICIAL_REGIONS.duplicate()


static func is_official_region(region_name: String) -> bool:
	return OFFICIAL_REGIONS.has(region_name.strip_edges())


static func load_regions(path: String = REGIONS_PATH) -> PackedStringArray:
	var loaded := PackedStringArray()
	var data := LocalStorage.load_res_dictionary(path)
	if data.is_empty():
		push_warning(
			"RegionService: Failed to load '%s'. Using official 18-region fallback." % path
		)
		return get_fallback_regions()

	var list: Variant = data.get("regions", null)
	if list == null or not (list is Array):
		push_warning(
			"RegionService: Missing or invalid 'regions' array in '%s'. Using fallback." % path
		)
		return get_fallback_regions()

	for item: Variant in list:
		var region_name := str(item).strip_edges()
		if region_name.is_empty():
			continue
		if region_name == "Fancy" or region_name == "Poké Ball" or region_name == "Poke Ball":
			push_warning("RegionService: Skipping non-habitat pattern '%s'." % region_name)
			continue
		loaded.append(region_name)

	if loaded.is_empty():
		push_warning(
			"RegionService: No usable regions in '%s'. Using official 18-region fallback." % path
		)
		return get_fallback_regions()

	return loaded


static func filter_to_official(regions: PackedStringArray) -> PackedStringArray:
	var filtered := PackedStringArray()
	for region_name: String in regions:
		var cleaned := region_name.strip_edges()
		if is_official_region(cleaned) and not filtered.has(cleaned):
			filtered.append(cleaned)
	return filtered

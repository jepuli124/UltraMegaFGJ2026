const NUMBER_OF_COLOURS = 4
const NUMBER_OF_MESSAGES_PER_CHARACTER = 3
const NUMBER_OF_INNOCENTS_PER_TRAVEL_GROUP = 2

# placeholder of an actual global because I can't be bothered
const COLOURS = ["red", "green", "blue", "yellow"]

static var TARGET_REFERENCE_METHODS = [
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "A person next to me", "possible_targets": [(source_index+1)%list_of_characters_in_order.size(), (((source_index-1)%list_of_characters_in_order.size()) if source_index > 0 else list_of_characters_in_order.size()-1)]}, 
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return (source_index+1)%list_of_characters_in_order.size() == target_index or (((source_index-1)%list_of_characters_in_order.size()) if source_index > 0 else list_of_characters_in_order.size()-1) == target_index
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		var possible_targets = []
		for npc_index in range(list_of_characters_in_order.size()):
			if npc_index != source_index and COLOURS[list_of_characters_in_order[target_index]["colour"]] == COLOURS[list_of_characters_in_order[npc_index]["colour"]]:
				possible_targets.append(npc_index)
		return {"text": "Someone with a " + COLOURS[list_of_characters_in_order[target_index]["colour"]] + " mask", "possible_targets": possible_targets},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return true
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		var steps = min((((source_index-target_index)%list_of_characters_in_order.size()) if source_index-target_index >= 0 else (((source_index-target_index)%list_of_characters_in_order.size() + list_of_characters_in_order.size()))),
		(((target_index-source_index)%list_of_characters_in_order.size()) if target_index-source_index >= 0 else (((target_index-source_index)%list_of_characters_in_order.size() + list_of_characters_in_order.size()))))
		var possible_targets = [(((source_index-steps)%list_of_characters_in_order.size()) if source_index-steps >= 0 else (((source_index-steps)%list_of_characters_in_order.size() + list_of_characters_in_order.size()))),
		 (((steps-source_index)%list_of_characters_in_order.size()) if steps-source_index >= 0 else (((steps-source_index)%list_of_characters_in_order.size() + list_of_characters_in_order.size())))]
		return {"text": "Someone who is " + var_to_str(steps) + " steps from me", "possible_targets": possible_targets},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return (source_index+1)%list_of_characters_in_order.size() != target_index and (((source_index-1)%list_of_characters_in_order.size()) if source_index > 0 else list_of_characters_in_order.size()-1) != target_index
		}
]

static var MESSAGE_CONTENT_METHODS = [
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "traveled with me.", "source": source_index, "contradicting_contents": [1, 2, 3, 4], "content_id": 0},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return list_of_characters_in_order[source_index]["travel_companions"].has(target_index)
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "did not travel with me", "source": source_index, "contradicting_contents": [0], "content_id": 1},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return not list_of_characters_in_order[source_index]["travel_companions"].has(target_index)
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "did not travel with me but shares a mask colour with someone who did.", "source": source_index, "contradicting_contents": [0, 3], "content_id": 2},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return list_of_characters_in_order[source_index]["travel_companions"].map(func (companion_index):
			return list_of_characters_in_order[companion_index]["colour"]
			).has(list_of_characters_in_order[target_index]["colour"]) and not list_of_characters_in_order[source_index]["travel_companions"].has(target_index)
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "did not travel with me and does not share a mask colour with anyone who did.", "source": source_index, "contradicting_contents": [0, 2], "content_id": 3},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return not list_of_characters_in_order[source_index]["travel_companions"].map(func (companion_index):
			return list_of_characters_in_order[companion_index]["colour"]
			).has(list_of_characters_in_order[target_index]["colour"]) and not list_of_characters_in_order[source_index]["travel_companions"].has(target_index)
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "is lying.", "source": source_index, "contradicting_contents": [0, 5], "content_id": 4},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return list_of_characters_in_order[target_index]["is_assasin"] and 2 > randi_range(0,9)
		},
	{"formatter": func (list_of_characters_in_order, source_index, target_index):
		return {"text": "is telling the truth.", "source": source_index, "contradicting_contents": [4], "content_id": 5},
	"validator": func (list_of_characters_in_order, source_index, target_index) -> bool:
		return not list_of_characters_in_order[target_index]["is_assasin"] and 2 > randi_range(0,9)
		}
]

static func generate_puzzle(number_of_characters: int, number_of_assasins: int):
	# number_of_characters must be at least 3
	
	if (number_of_assasins > number_of_characters):
		number_of_assasins = number_of_characters
	var list_of_characters_in_order = null
	
	while (list_of_characters_in_order == null or not _validate_puzzle(list_of_characters_in_order)):
		list_of_characters_in_order = []
		for i in range(number_of_characters):
			list_of_characters_in_order.append(
				{"is_assasin": i<number_of_assasins, 
				"colour": randi_range(0, NUMBER_OF_COLOURS-1), 
				"travel_companions": [],
				"messages": []}
			)
		list_of_characters_in_order.shuffle()
		_generate_travel_groups(list_of_characters_in_order)
		_generate_messages(list_of_characters_in_order)
	
	return list_of_characters_in_order
	
static func _generate_travel_groups(list_of_characters_in_order) -> void:
	var travel_groups = []
	var group_indeces = []
	for n in range(ceili(list_of_characters_in_order.size() / NUMBER_OF_INNOCENTS_PER_TRAVEL_GROUP)):
		travel_groups.append([])
		
	for npc_index in range(list_of_characters_in_order.size()):
		if not list_of_characters_in_order[npc_index]["is_assasin"]:
			var group_index = randi_range(0, travel_groups.size()-1)
			group_indeces.append(group_index)
			travel_groups[group_index].append(npc_index)
		else:
			group_indeces.append(-1)
			
	for npc_index in range(list_of_characters_in_order.size()):
		if not list_of_characters_in_order[npc_index]["is_assasin"]:
			for companion in travel_groups[group_indeces[npc_index]]:
				if companion != npc_index:
					list_of_characters_in_order[npc_index]["travel_companions"].append(companion)
	return
	
static func _generate_messages(list_of_characters_in_order) -> void:
	var source_indeces = range(list_of_characters_in_order.size())
	source_indeces.shuffle()
	for source_index in source_indeces:
		for message_index in range(NUMBER_OF_MESSAGES_PER_CHARACTER):
			var target_index = randi_range(0, list_of_characters_in_order.size() - 2)
			if target_index >= source_index:
				target_index += 1
				
			var possible_target_strings = []
			for reference_method in TARGET_REFERENCE_METHODS:
				if list_of_characters_in_order[source_index]["is_assasin"] or reference_method["validator"].call(list_of_characters_in_order, source_index, target_index):
					possible_target_strings.append(reference_method["formatter"].call(list_of_characters_in_order, source_index, target_index))
			var target_string = possible_target_strings[randi_range(0, max(0, possible_target_strings.size()-1))]
				
			var possible_constent_strings = []
			for content_method in MESSAGE_CONTENT_METHODS:
				if list_of_characters_in_order[source_index]["is_assasin"]:
					# randomize target to some other target than source or actual target
					var fake_target_index = randi_range(0, list_of_characters_in_order.size() - 3)
					if fake_target_index >= source_index:
						fake_target_index += 1
					if fake_target_index >= target_index:
						fake_target_index += 1
					possible_constent_strings.append(content_method["formatter"].call(list_of_characters_in_order, source_index, fake_target_index))
				elif content_method["validator"].call(list_of_characters_in_order, source_index, target_index):
					possible_constent_strings.append(content_method["formatter"].call(list_of_characters_in_order, source_index, target_index))
			var constent_string = possible_constent_strings[randi_range(0, max(0, possible_constent_strings.size()-1))]
			
			list_of_characters_in_order[source_index]["messages"].append({
				"text": target_string["text"] + " " + constent_string["text"], 
				"possible_targets": target_string["possible_targets"], 
				"contradicting_contents": constent_string["contradicting_contents"],
				"content_id": constent_string["content_id"]
				})
	

static func _validate_puzzle(list_of_characters_in_order) -> bool:
	var message_grid = []
	for source_index in range(list_of_characters_in_order.size()):
		for message_index in range(NUMBER_OF_MESSAGES_PER_CHARACTER):
			var message_row = []
			for target_index in range(list_of_characters_in_order.size()):	
				if list_of_characters_in_order[source_index]["messages"][message_index]["possible_targets"].has(target_index):
					message_row.append([list_of_characters_in_order[source_index]["messages"][message_index]["content_id"], list_of_characters_in_order[source_index]["messages"][message_index]["contradicting_contents"]])
				else:
					message_row.append(-1)
			message_grid.append(message_row)
	
	return _validate_solutions(list_of_characters_in_order, message_grid) == 1
	
static func _validate_solutions(list_of_characters_in_order, message_grid, ignored_rows = [], number_of_assasins = null) -> int:
	if number_of_assasins == null:
		number_of_assasins = list_of_characters_in_order.map(func (c): return c["is_assasin"]).count(true)
		
	var valid_solutions = 0

	if ignored_rows.size() < number_of_assasins:
		for ignore_index in range(ignored_rows.max() if ignored_rows.size() > 0 else 0, list_of_characters_in_order.size()):
			ignored_rows.append(ignore_index)
			valid_solutions += _validate_solutions(list_of_characters_in_order, message_grid, ignored_rows, number_of_assasins)
			ignored_rows.pop_back()
	else:
		for grid in _get_simplified_grids(message_grid, ignored_rows):
			if _validate_message_grid(grid, ignored_rows):
				valid_solutions += 1
				break
	return valid_solutions
	
static func _get_simplified_grids(message_grid, ignored_rows, row_index = 0, grids = []):
	if row_index >= message_grid.size():
		grids.append(message_grid)
		return grids
		
	if message_grid[row_index].count(-1) > 1:
		var active_indeces = []
		for i in range(message_grid[row_index].size()):
			if message_grid[row_index][i] is Array:
				active_indeces.append({"index": i, "value": message_grid[row_index][i]})
				message_grid[row_index][i] = -1
		for active_index in active_indeces:
			message_grid[row_index][active_index["index"]] = active_index["value"]
			_get_simplified_grids(message_grid, ignored_rows, row_index+1, grids)
			message_grid[row_index][active_index["index"]] = -1
	else:
		return _get_simplified_grids(message_grid, ignored_rows, row_index+1, grids)
		
	return grids

static func _validate_message_grid(message_grid, ignored_rows, row_index = 0) -> bool:
	for target_index in range(message_grid[0].size()):
		var statements = []
		for source_index in range(message_grid.size()):
			if message_grid[source_index][target_index] != -1 and not ignored_rows.has(floor(source_index / NUMBER_OF_MESSAGES_PER_CHARACTER)):
				statements.append(message_grid[source_index][target_index])
		for statement in statements:
			for contradicting in statement[1]:
				if contradicting in statements:
					return false
	return true

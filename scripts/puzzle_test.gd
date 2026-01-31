extends Node2D

const puzzle_gen = preload("res://scripts/puzzle_generator.gd")




func _on_ready():
	var puzzle = puzzle_gen.generate_puzzle(8, 2)
	for npc in puzzle:
		print(puzzle_gen.COLOURS[npc["colour"]])
		for msg in npc["messages"]:
			print(msg["text"])
		print()
		
	for npc in puzzle:
		print(puzzle_gen.COLOURS[npc["colour"]], " ", npc["is_assasin"])

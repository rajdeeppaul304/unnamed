extends Node

var scenes_dict = {
	"level_1_scene": preload("res://scenes/player/player-scene.tscn")
}

var decision_tree: DecisionTree

func _ready():
	decision_tree = DecisionTree.new()
	decision_tree.load_from_json("res://data/level1.json")
	var root := decision_tree.find_node_by_id("root")
	
	#decision_tree.init("asdf", scenes_dict["level_1_scene"], )

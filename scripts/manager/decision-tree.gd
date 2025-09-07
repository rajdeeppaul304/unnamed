# DecisionTree.gd
extends Node
class_name DecisionTree

#const DecisionNode = preload("res://path/to/DecisionNode.gd")

var scene_cache := {} # Cache preloaded scenes
var root: DecisionNode

# Public function to load the tree
func load_from_json(json_path: String) -> void:
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		push_error("Failed to open JSON file: " + json_path)
		return

	var json_str = file.get_as_text()
	var result = JSON.parse_string(json_str)
	if result == null:
		push_error("Invalid JSON")
		return
	
	var nodes_dict: Dictionary[String, DecisionNode] = {}
	
	for node in result.get("nodes", []):
		var scene_path: String = node.get("scene", "")
		var node_id: String = node.get("id", "")

		# Preload or reuse cached scene
		var scene: PackedScene = _get_or_preload_scene(scene_path)
		
		var new_node: DecisionNode = DecisionNode.new()
		new_node.init(node_id, scene)
		nodes_dict[node.get("id", "")] = new_node
	
	root = _build_tree(nodes_dict)

# function to add childrens to the root node from node_dict
func _build_tree(nodes_dict: Dictionary[String, DecisionNode]) -> DecisionNode:
	var root_node = nodes_dict.get("0")
	
	for key in nodes_dict.keys():
		var parent_id = key.rsplit("_", true, 1)[0]
		
		if parent_id != key:
			print("adding children " + key + " for parent " + parent_id)
			nodes_dict[parent_id].add_child_node(nodes_dict[key])

	if root_node == null:
		printerr("root not found in decision tree")
	return root_node

# Caches preloaded scenes to avoid redundant loading
func _get_or_preload_scene(path: String) -> PackedScene:
	if scene_cache.has(path):
		return scene_cache[path]
	if path == "":
		return null
	var scene: PackedScene = load(path)
	scene_cache[path] = scene
	return scene

# Traverse and print node IDs (for testing)
func traverse(node: DecisionNode = null, indent: int = 0) -> void:
	if node == null:
		node = root
	#print("  " + indent + "- " + node.node_id)
	for child in node.child_nodes:
		traverse(child, indent + 1)


# Get node by ID (DFS)
func find_node_by_id(target_id: String, node: DecisionNode = null) -> DecisionNode:
	
	if node == null:
		node = root
	if node.node_id == target_id:
		#print("node is same as target ", target_id)
		return node
	for child in node.child_nodes:
		var result = find_node_by_id(target_id, child)
		if result != null:
			#print("found node in one of the childrens ", target_id)
			return result
	return null

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

	root = _build_tree(result)

# Recursive function to build tree
func _build_tree(data: Dictionary) -> DecisionNode:
	var scene_path: String = data.get("scene", "")
	var node_id: String = data.get("id", "")
	var children_data: Array = data.get("children", [])

	# Preload or reuse cached scene
	var scene: PackedScene = _get_or_preload_scene(scene_path)

	# Create and initialize DecisionNode
	var node := DecisionNode.new()
	node.init(node_id, scene)

	# Recursively build children
	for child_dict in children_data:
		var child_node := _build_tree(child_dict)
		node.add_child_node(child_node)

	return node

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
		#printerr("root is noll")
		node = root
	if node.node_id == target_id:
		printerr(node.node_id)
		return node
	for child in node.child_nodes:
		var result = find_node_by_id(target_id, child)
		if result != null:
			print(node.node_id)
			return result
	return null

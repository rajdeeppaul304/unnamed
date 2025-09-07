# DecisionNode.gd
class_name DecisionNode
extends Node

var node_id: String
var node_scene: PackedScene
var child_nodes: Array[DecisionNode] = []

func init(id: String, scene: PackedScene) -> void:
	node_id = id
	node_scene = scene
	child_nodes = []

func add_child_node(child: DecisionNode) -> void:
	child_nodes.append(child)

func get_child_by_id(id: String) -> DecisionNode:
	for child in child_nodes:
		if child.node_id == id:
			return child
	return null

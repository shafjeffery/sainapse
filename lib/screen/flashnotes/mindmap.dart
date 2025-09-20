import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:convert';

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    _loadDummyMindMap();
  }

  void _loadDummyMindMap() {
    // Dummy JSON (later replace with AWS response)
    const dummyJson = '''
    {
      "root": "Zoology",
      "children": [
        {
          "name": "General Concepts",
          "children": [
            {"name": "History"},
            {"name": "Classification"}
          ]
        },
        {
          "name": "Cell Zoology",
          "children": [
            {"name": "Cytology"},
            {"name": "Molecular Biology"}
          ]
        },
        {
          "name": "Behavioral Zoology",
          "children": [
            {"name": "Comparative Anatomy"},
            {"name": "Ethology"}
          ]
        }
      ]
    }
    ''';

    final data = json.decode(dummyJson);
    final root = Node.Id(data["root"]);
    graph.addNode(root);
    _addChildren(root, data["children"]);
  }

  void _addChildren(Node parent, List<dynamic>? children) {
    if (children == null) return;
    for (var child in children) {
      final childNode = Node.Id(child["name"]);
      graph.addEdge(parent, childNode);
      _addChildren(childNode, child["children"]);
    }
  }

  Widget nodeWidget(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown, width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Flash Notes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Mind Map",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),

          // Graph container
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.6,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(
                  builder,
                  TreeEdgeRenderer(builder),
                ),
                builder: (Node node) {
                  var label = node.key?.value as String;
                  return nodeWidget(label);
                },
              ),
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mind Map saved into folder (dummy)"),
                    ),
                  );
                },
                child: const Text(
                  "Save Into Folder",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

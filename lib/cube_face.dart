import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'cube_model_page.dart';

class CubeFace extends StatefulWidget {
  final List<List<String>> colorLayout;
  final String centerColor;
  final String faceName;

  const CubeFace({super.key, required this.colorLayout, required this.centerColor, required this.faceName});

  @override
  _CubeFaceState createState() => _CubeFaceState();
}

class _CubeFaceState extends State<CubeFace> {
  late List<List<Color>> cubeFaceColors;
  late List<List<String>> updatedColorLayout;

  @override
  void initState() {
    super.initState();
    // Initialize the color grid and a layout for storing color names
    cubeFaceColors = widget.colorLayout.map(
      (row) => row.map((color) => colorMapping[color] ?? Colors.grey).toList(),
    ).toList();
    updatedColorLayout = widget.colorLayout;

    // Set the center square to the specific color for this face
    cubeFaceColors[1][1] = colorMapping[widget.centerColor] ?? Colors.grey;
    updatedColorLayout[1][1] = widget.centerColor;
  }

  void changeColor(int row, int col) {
    if (row == 1 && col == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Center Square"),
            content: Text("The center square must remain ${widget.centerColor.toUpperCase()}."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      int currentIndex = colorMapping.values.toList().indexOf(cubeFaceColors[row][col]);
      Color newColor = colorMapping.values.toList()[(currentIndex + 1) % colorMapping.length];
      cubeFaceColors[row][col] = newColor;

      // Update the color name in updatedColorLayout
      String colorName = colorMapping.entries.firstWhere((entry) => entry.value == newColor).key;
      updatedColorLayout[row][col] = colorName;
    });
  }

  void onDone() {
    if(currentFaceIndex >= 5){
      String currentFace = widget.faceName.toLowerCase();
      cubeLayouts[currentFace] = updatedColorLayout;
      print(cubeLayouts);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RubiksCubeModel(cubeLayouts: cubeLayouts),
        ),
      );
    }
    else{
      Navigator.pop(context, updatedColorLayout);  // Return updated layout
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.faceName} Face'),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => changeColor(row, col),
                  child: Container(
                    color: cubeFaceColors[row][col],
                    margin: const EdgeInsets.all(4),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}


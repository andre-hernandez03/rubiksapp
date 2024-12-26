/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

// Define possible colors for the Rubik's Cube face
const Map<String, Color> colorMapping = {
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow,
  'white': Colors.white,
  'orange': Colors.orange,
};

class CameraWithDynamicBox extends StatefulWidget {
  const CameraWithDynamicBox({super.key});

  @override
  _CameraWithDynamicBoxState createState() => _CameraWithDynamicBoxState();
}

class _CameraWithDynamicBoxState extends State<CameraWithDynamicBox> {
  CameraController? _controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    await _controller!.initialize();

    if (!mounted) return;
    setState(() {});
  }

  Future<void> captureAndSendImage() async {
    try {
      final XFile imageFile = await _controller!.takePicture();
      File file = File(imageFile.path);
      final colorLayout = await sendToBackend(file);

      final updatedColorLayout = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CubeFace(colorLayout: colorLayout),
        ),
      );

      if (updatedColorLayout != null) {
        // Update with the modified layout if changes were made
        setState(() {
          // Use the updated color layout as needed here
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<List<List<String>>> sendToBackend(File file) async {
    var url = Uri.parse('https://rubiksapi.onrender.com/detect');
    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = jsonDecode(responseData.body);

        if (data != null && data.containsKey('layout')) {
          return (data['layout'] as List)
              .map((row) => (row as List).map((color) => color.toString()).toList())
              .toList();
        } else {
          print('Error: Expected data structure not found.');
        }
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image to backend: $e');
    }

    // Return a default layout (e.g., 'unknown' colors) in case of an error
    return List.generate(3, (_) => List.generate(3, (_) => 'unknown'));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.6;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan white face')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Center(
            child: Container(
              width: boxWidth,
              height: boxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureAndSendImage,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class CubeFace extends StatefulWidget {
  final List<List<String>> colorLayout;

  const CubeFace({super.key, required this.colorLayout});

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
    updatedColorLayout = widget.colorLayout; // Track the updated colors by name

    //keep middle unchanged
    cubeFaceColors[1][1] = Colors.white;
    updatedColorLayout[1][1] = 'white';
  }

  // Method to change the color and update the color name
  void changeColor(int row, int col) {
    if (row == 1 && col == 1) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Center Square"),
          content: const Text("Center square must be white"),
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
      // Cycle to the next color and update the color list and name list
      Color newColor = colorMapping.values.toList()[(currentIndex + 1) % colorMapping.length];
      cubeFaceColors[row][col] = newColor;

      // Update the color name in updatedColorLayout
      String colorName = colorMapping.entries.firstWhere((entry) => entry.value == newColor).key;
      updatedColorLayout[row][col] = colorName;
    });
  }

  // Method to handle the "Done" button press
  void onDone() {
    Navigator.pop(context, updatedColorLayout);  // Return updated layout
    print(updatedColorLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rubik\'s Cube Face'),
      ),
      body: Column(
        children: [
          const Spacer(),  // Pushes the grid to the top, keeping the button at the bottom
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
          const Spacer(),  // Pushes the button to the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'cube_face.dart';
//import 'cube_model_page.dart';

// Define possible colors for the Rubik's Cube face
const Map<String, Color> colorMapping = {
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow,
  'white': Colors.white,
  'orange': Colors.orange,
};

// Define the sequence of face colors and names
final List<String> faceColors = [
  'white',
  'red',
  'green',
  'orange',
  'blue',
  'yellow'
];
int currentFaceIndex = 0;
Map<String, List<List<String>>> cubeLayouts = {};

class CameraWithDynamicBox extends StatefulWidget {
  const CameraWithDynamicBox({super.key});

  @override
  _CameraWithDynamicBoxState createState() => _CameraWithDynamicBoxState();
}

class _CameraWithDynamicBoxState extends State<CameraWithDynamicBox> {
  CameraController? _controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    await _controller!.initialize();

    if (!mounted) return;
    setState(() {});
  }

  Future<void> captureAndSendImage() async {
    try {
      final XFile imageFile = await _controller!.takePicture();
      File file = File(imageFile.path);
      final colorLayout = await sendToBackend(file);

      // Navigate to CubeFace to allow the user to make adjustments
      final updatedColorLayout = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CubeFace(
            colorLayout: colorLayout,
            centerColor: faceColors[
                currentFaceIndex], // Set center color based on face order
            faceName: faceColors[currentFaceIndex]
                .toUpperCase(), // Pass current face name
          ),
        ),
      );

      // Save the updated layout for the current face
      String currentFace = faceColors[currentFaceIndex];
      cubeLayouts[currentFace] = updatedColorLayout;

      // Move to the next face
      setState(() {
        currentFaceIndex++;
      });

      if (currentFaceIndex < faceColors.length) {
        // Prompt user to scan the next face
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Next Face"),
              content: Text(
                  "Please scan the ${faceColors[currentFaceIndex].toUpperCase()} face."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<List<List<String>>> sendToBackend(File file) async {
    var url = Uri.parse('https://rubiksapi.onrender.com/detect');
    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = jsonDecode(responseData.body);

        if (data != null && data.containsKey('layout')) {
          return (data['layout'] as List)
              .map((row) =>
                  (row as List).map((color) => color.toString()).toList())
              .toList();
        } else {
          print('Error: Expected data structure not found.');
        }
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image to backend: $e');
    }

    return List.generate(3, (_) => List.generate(3, (_) => 'unknown'));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.6;

    return Scaffold(
      appBar: AppBar(
          title:
              Text('Scan ${faceColors[currentFaceIndex].toUpperCase()} Face')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Center(
            child: Container(
              width: boxWidth,
              height: boxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureAndSendImage,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

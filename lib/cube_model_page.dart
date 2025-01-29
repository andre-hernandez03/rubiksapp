import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cube/flutter_cube.dart';

//import 'package:rubiks/camera_page.dart';
//import 'package:rubiks/camera_page.dart';

// Define color mappings for Rubik's Cube face colors
const Map<String, Color> colorMap = {
  'blue': Colors.blue,
  'orange': Colors.orange,
  'green': Colors.green,
  'red': Colors.red,
  'white': Colors.white,
  'yellow': Colors.yellow,
};

class RubiksCubeModel extends StatelessWidget {
  final Map<String, List<List<String>>> cubeLayouts;

  const RubiksCubeModel({super.key, required this.cubeLayouts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Rubik\'s Cube Model'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildFaceGrid(context, cubeLayouts['yellow']!, "top"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _buildFaceGrid(context, cubeLayouts['blue']!, "left"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _buildFaceGrid(context, cubeLayouts['red']!, "mid"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                      _buildFaceGrid(context, cubeLayouts['green']!, "right"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _buildFaceGrid(
                      context, cubeLayouts['orange']!, "rightmost"),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildFaceGrid(context, cubeLayouts['white']!, "bottom"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the 3D model page with cubeLayouts data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          //RubiksCubeImage(cubeLayouts: cubeLayouts),
                          RubiksCube(cubeLayouts: cubeLayouts)
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("View in 3D"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceGrid(
      BuildContext context, List<List<String>> faceColors, String label) {
    final gridSize = MediaQuery.of(context).size.width * 0.22;

    return Column(
      children: [
        //Text(label,
        //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          width: gridSize,
          height: gridSize,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 1), // Black border around each face
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;
              Color color = colorMap[faceColors[row][col]] ?? Colors.grey;
              return Container(
                color: color,
                margin: const EdgeInsets.all(
                    2), // Adjust margin to control space between squares
              );
            },
          ),
        ),
      ],
    );
  }
}



/*
class _RubiksCubeImageState extends State<RubiksCubeImage> {
  Uint8List? imageUrl;

  Future<void> fetchCubeImage() async {
    final response = await http.post(
      Uri.parse('https://rubiksapi.onrender.com/render_cube'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'colors': widget.cubeLayouts}),
    );

    if (response.statusCode == 200) {
      print('works');
      setState(() {
        imageUrl = response.bodyBytes;
      });
    } else {
      print('Failed to load image. Status code: ${response.statusCode}');
    }
  }

  Future<void> sendRotationToServer(
      Map<String, List<List<String>>> colors, String rotation) async {
    final url = Uri.parse(
        'https://rubiksapi.onrender.com/rot'); // Replace with your server's address
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'colors': widget.cubeLayouts,
          'rot': rotation,
        }),
      );

      if (response.statusCode == 200) {
        print('Rotation sent successfully: ${response.body}');
        imageUrl = response.bodyBytes;
      } else {
        print('Failed to send rotation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending rotation: $e');
    }
    fetchCubeImage();
    cubeLayouts = colors;
  }
  

  @override
  void initState() {
    super.initState();
    fetchCubeImage();
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Rubik\'s Cube Image')),
      body: Center(
            child: imageUrl != null
              ? Image.memory(imageUrl!)
              : const CircularProgressIndicator(),
        )
      );
  }
  */

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rubik\'s Cube Controller')),
      body: Column(
        children: [
          // Display the cube image
          Expanded(
            child: imageUrl != null
                ? Image.memory(imageUrl!)
                : const CircularProgressIndicator(),
          ),
          // Rotation buttons
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'ff'),
                child: const Text('FF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'ffc'),
                child: const Text('FFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'bf'),
                child: const Text('BF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'bfc'),
                child: const Text('BFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'lf'),
                child: const Text('LF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'lfc'),
                child: const Text('LFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'rf'),
                child: const Text('RF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'rfc'),
                child: const Text('RFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'tf'),
                child: const Text('TF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'tfc'),
                child: const Text('TFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'bof'),
                child: const Text('BOF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts,'bofc'),
                child: const Text('BOFC'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/

/*
class RubiksCubeImage extends StatefulWidget {
  final Map<String, List<List<String>>> cubeLayouts;
  //late Map<String, List<List<String>>> cubeLayouts = {};

  RubiksCubeImage({required this.cubeLayouts});

  @override
  _RubiksCubeImageState createState() => _RubiksCubeImageState();
}

class _RubiksCubeImageState extends State<RubiksCubeImage> {
  Uint8List? imageUrl;
  //late Map<String, List<List<String>>> cubeLayouts;

  @override
  void initState() {
    super.initState();
    //cubeLayouts = Map.from(widget.cubeLayouts); // Clone initial layout
    fetchCubeImage();
  }

  Future<void> fetchCubeImage([Map<String, List<List<String>>>? layout]) async {
    try {
      final colors = layout ?? cubeLayouts;

      final response = await http.post(
        Uri.parse('https://rubiksapi.onrender.com/render_cube'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'colors': colors}),
      );

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        if (!mounted) return;
        setState(() {
          imageUrl = imageBytes;
          cubeLayouts = colors; // Update the layout state
        });
      } else {
        showError('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error fetching image: $e');
    }
  }

  Future<void> sendRotationToServer(
      Map<String, List<List<String>>> colors, String rotation) async {
    final url = Uri.parse('https://rubiksapi.onrender.com/rot');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'colors': cubeLayouts, 'rot': rotation}),
      );

      if (response.statusCode == 200) {
        print('Rotation sent successfully.');

        final data = jsonDecode(response.body);
        final updatedColors = Map<String, List<List<String>>>.from(data['colors']);
        
        // Fetch the updated image with the new layout
        await fetchCubeImage(updatedColors);
      } else {
        showError('Failed to send rotation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error sending rotation: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rubik\'s Cube Controller')),
      body: Column(
        children: [
          // Display the cube image
          Expanded(
            child: imageUrl != null
                ? Image.memory(imageUrl!)
                : const Center(child: CircularProgressIndicator()),
          ),
          // Rotation buttons
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'ff'),
                child: const Text('FF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'ffc'),
                child: const Text('FFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'bf'),
                child: const Text('BF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'bfc'),
                child: const Text('BFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'lf'),
                child: const Text('LF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'lfc'),
                child: const Text('LFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'rf'),
                child: const Text('RF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'rfc'),
                child: const Text('RFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'tf'),
                child: const Text('TF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'tfc'),
                child: const Text('TFC'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'bof'),
                child: const Text('BOF'),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer(cubeLayouts, 'bofc'),
                child: const Text('BOFC'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/

class RubiksCubeImage extends StatefulWidget {
  final Map<String, List<List<String>>> cubeLayouts;

  const RubiksCubeImage({super.key, required this.cubeLayouts});

  @override
  _RubiksCubeImageState createState() => _RubiksCubeImageState();
}

class _RubiksCubeImageState extends State<RubiksCubeImage> {
  Uint8List? imageUrl;
  late Map<String, List<List<String>>> cubeLayouts;

  @override
  void initState() {
    super.initState();
    cubeLayouts = Map.from(widget.cubeLayouts); // Clone initial layout
    fetchCubeImage();
  }

  Future<void> fetchCubeImage() async {
    try {
      final response = await http.post(
        Uri.parse('https://rubiksapi.onrender.com/render_cube'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'colors': cubeLayouts}), // Use current cubeLayouts
      );

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        if (!mounted) return;
        setState(() {
          imageUrl = imageBytes;
        });
      } else {
        showError('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error fetching image: $e');
    }
  }

  Future<void> sendRotationToServer(String rotation) async {
    final url = Uri.parse('https://rubiksapi.onrender.com/rot');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'colors': cubeLayouts, 'rot': rotation}),
      );

      if (response.statusCode == 200) {
        print('Rotation sent successfully.');

        final data = jsonDecode(response.body);
        // Parse colors into the required format
        final updatedColors = (data['colors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((row) => List<String>.from(row)).toList(),
        ),
      );
        setState(() {
          //cubeLayouts = Map<String, List<List<String>>>.from(data['colors']); // Update cubeLayouts
          cubeLayouts = updatedColors;
        });

        // Fetch the updated image
        await fetchCubeImage();
      } else {
        showError('Failed to send rotation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error sending rotation: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

    Future<void> scramble() async {
    final url = Uri.parse('https://rubiksapi.onrender.com/scramble');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'colors': cubeLayouts}),
      );

      if (response.statusCode == 200) {
        print('Rotation sent successfully.');

        final data = jsonDecode(response.body);
        // Parse colors into the required format
        final updatedColors = (data['colors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((row) => List<String>.from(row)).toList(),
        ),
      );
        setState(() {
          //cubeLayouts = Map<String, List<List<String>>>.from(data['colors']); // Update cubeLayouts
          cubeLayouts = updatedColors;
        });

        // Fetch the updated image
        await fetchCubeImage();
      } else {
        showError('Failed to send scramble. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error sending scramble: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rubik\'s Cube Viewer')),
      body: Column(
        children: [
          // Display the cube image
          Expanded(
            child: imageUrl != null
                ? Image.memory(imageUrl!)
                : const Center(child: CircularProgressIndicator()),
          ),
          // Rotation buttons
          Flexible ( 
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
            children: [
              ElevatedButton(
                onPressed: () => sendRotationToServer('ff'),
                style: ElevatedButton.styleFrom(maximumSize: const Size(65, 65),
                ),
                child: const Text('Front Face CW',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('ffc'),
                child: const Text('Front Face CCW',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('bf'),
                child: const Text('Back Face CW',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('bfc'),
                child: const Text('Back Face CCW',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('lf'),
                child: const Text('Left Face Down',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('lfc'),
                child: const Text('Left Face Up',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('rf'),
                child: const Text('Right Face Down',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('rfc'),
                child: const Text('Right Face Up',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('tf'),
                child: const Text('Top Face Left',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('tfc'),
                child: const Text('Top Face Right',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('bof'),
                child: const Text('Bottom Face Left',style: TextStyle(color:Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () => sendRotationToServer('bofc'),
                child: const Text('Bottom Face Right',style: TextStyle(color:Colors.blue)),
              ),
            ],
          ),
          ),
          ElevatedButton(onPressed: () => scramble(),
          style:ElevatedButton.styleFrom(backgroundColor: Colors.blue), 
          child: const Text('Scramble',style: TextStyle(color:Colors.white))),
        ],
      ),
    );
  }
}

class RubiksCube extends StatefulWidget {
    final Map<String, List<List<String>>> cubeLayouts;

    const RubiksCube({super.key, required this.cubeLayouts});

  @override
  _RubiksCubeState createState() => _RubiksCubeState();
}

class _RubiksCubeState extends State<RubiksCube> {
  late Object cube;
  late Map<String, List<List<String>>> cubeLayouts;


  @override
  void initState() {
    super.initState();

        // Colors for each face (9 squares per face)
      List<List<Color>> faceColors = [
      List.filled(9, Colors.orange),    // Front face
      List.filled(9, Colors.red),   // Back face
      List.filled(9, Colors.blue),  // Left face
      List.filled(9, Colors.green),     // Right face
      List.filled(9, Colors.yellow),   // Top face
      List.filled(9, Colors.white),  // Bottom face
    ];

    cubeLayouts = Map.from(widget.cubeLayouts);
    
    Map<String, Color> colorMapping = {
      "white": Colors.white,
      "red": Colors.red,
      "blue": Colors.blue,
      "green": Colors.green,
      "orange": Colors.orange,
      "yellow": Colors.yellow,
    };

      Map<String, List<Color>> convertCubeColors(Map<String, List<List<String>>> cube) {
      return cube.map((key, value) => MapEntry(
          key,
          value.expand((row) => row.map((color) => colorMapping[color] ?? Colors.black)).toList(),
        ));
  }

    Map<String, List<Color>> cubeLayoutColor = convertCubeColors(cubeLayouts);

    //print(cubeLayoutColor);
    faceColors[0] = cubeLayoutColor["orange"]!;
    faceColors[1] = cubeLayoutColor["red"]!;
    faceColors[2] = cubeLayoutColor["blue"]!;
    faceColors[3] = cubeLayoutColor["green"]!;
    faceColors[4] = cubeLayoutColor["yellow"]!;
    faceColors[5] = cubeLayoutColor["white"]!;

    // Create the 3D Cube object
    cube = Object(
      name: "cube",
      scale: Vector3(3, 3, 3),
      backfaceCulling: false, // Ensures visibility of all faces
      children: [
        // Customize each face with colors from the dictionary
        createFace('Front', faceColors[0], Vector3(0,0,0.5),Vector3.zero()),
        createFace('Back', faceColors[1],Vector3(0,0,-0.5),Vector3(0,180,0)),
        createFace('Left', faceColors[2], Vector3(0.5,0,0), Vector3(0,90,0)),
        createFace('Right', faceColors[3], Vector3(-0.5,0,0), Vector3(0,-90,0)),
        createFace('Top', faceColors[4], Vector3(0,0.5,0), Vector3(-90,0,180)),
        createFace('Bottom', faceColors[5], Vector3(0,-0.5,0),Vector3(90, 0, -180)),
      ],
    );
  }

Object createFace(
      String name, List<Color> colors, Vector3 position, Vector3 rotation) {
    final List<Object> squares = [];
    const double squareSize = 1.0 / 3.0;
    const double borderThickness = 0.01; // Border thickness
    const double borderOffset =
        0.004; // Raise borders slightly above the squares
    int colorIndex = 0; // Track color assignment

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final double xOffset = (col - 1) * squareSize;
        final double yOffset = (1 - row) * squareSize;

        // **Main Colored Square**
        Object coloredSquare = Object(
          name: "$name-$row-$col",
          position: Vector3(xOffset, yOffset, 0),
          mesh: Mesh(
            vertices: [
              Vector3(-squareSize / 2, squareSize / 2, 0), // Top-left
              Vector3(squareSize / 2, squareSize / 2, 0), // Top-right
              Vector3(squareSize / 2, -squareSize / 2, 0), // Bottom-right
              Vector3(-squareSize / 2, -squareSize / 2, 0), // Bottom-left
            ],
            indices: [
              Polygon(0, 2, 1),
              Polygon(0, 3, 2),
            ],
            colors:
                List.filled(4, colors[colorIndex++]), // Assign colors correctly
          ),
        );

        squares.add(coloredSquare);

        // **Add 4 Border Rectangles to Surround the Square**
        squares.addAll(_createSquareBorders(
            xOffset, yOffset, squareSize, borderThickness, borderOffset));
      }
    }

    return Object(
      name: name,
      position: position,
      rotation: rotation,
      backfaceCulling: false,
      children: squares,
    );
  }

  /// **Creates 4 separate thin border rectangles for a square**
  List<Object> _createSquareBorders(
      double x, double y, double size, double thickness, double offset) {
    return [
      _createBorder(
          "$x-$y-top", x, y + size / 2, size, thickness, offset), // Top border
      _createBorder("$x-$y-bottom", x, y - size / 2, size, thickness,
          offset), // Bottom border
      _createBorder("$x-$y-left", x - size / 2, y, thickness, size,
          offset), // Left border
      _createBorder("$x-$y-right", x + size / 2, y, thickness, size,
          offset), // Right border
    ];
  }

  /// **Creates a single thin rectangle as a border piece**
  Object _createBorder(String name, double x, double y, double width,
      double height, double offset) {
    return Object(
        name: name,
        position: Vector3(x, y, offset), // Push slightly forward
        mesh: Mesh(
          vertices: [
            Vector3(-width / 2, height / 2, 0),
            Vector3(width / 2, height / 2, 0),
            Vector3(width / 2, -height / 2, 0),
            Vector3(-width / 2, -height / 2, 0),
          ],
          indices: [
            Polygon(0, 1, 2), Polygon(0, 2, 3), // Render as a rectangle
          ],
          colors: List.filled(4, Colors.black), // Black border color
        ),
        backfaceCulling: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rubik's Cube 3D"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Cube(
          interactive: true, // Enables rotation with gestures
          onSceneCreated: (Scene scene) {
            scene.world.add(cube);
          },
        ),
      ),
    );
  }
}
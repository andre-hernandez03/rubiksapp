import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                          RubiksCubeImage(cubeLayouts: cubeLayouts),
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

  RubiksCubeImage({required this.cubeLayouts});

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

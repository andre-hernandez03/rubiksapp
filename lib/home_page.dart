import 'package:flutter/material.dart';
import 'package:rubiks/scan_page.dart';
//import 'scramble_page.dart';
import 'package:camera/camera.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// HOME PAGE

class MyHomePage extends StatefulWidget {

  final CameraDescription camera;
  const MyHomePage( {super.key,required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState(camera);
}

class _MyHomePageState extends State<MyHomePage> {
  final CameraDescription camera;
  _MyHomePageState(this.camera);
  @override
  Widget build(BuildContext context) {
    return 
Scaffold(
  floatingActionButton: FloatingActionButton(
    /*
    onPressed: () {
      // Add functionality for scanning Bluetooth devices here
      //final FlutterBluePlus flutterBlue = FlutterBluePlus();
      FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        for (var result in results) {
          print('\${result.device.name} (\${result.device.id})');
        }
      }).onDone(() {
        FlutterBluePlus.stopScan();
      });
    },*/
    onPressed: (){},
    tooltip: 'Scan Bluetooth',
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    child: const Icon(Icons.bluetooth),
  ),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Rubik's Cube Solver", style: TextStyle(color:Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Scan Button
            ElevatedButton(
              style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scanpage(title:'Scan Cube',camera:camera)),
                  );
              },
              child: const Text('Scan Cube',style: TextStyle(color:Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
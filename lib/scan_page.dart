import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_page.dart';

class Scanpage extends StatefulWidget {

  final CameraDescription camera;
  const Scanpage({super.key, required this.title, required this.camera});
  final String title;
  

  @override
  // ignore: no_logic_in_create_state
  State<Scanpage> createState() => _Scanpage(camera);
}

class _Scanpage extends State<Scanpage> 
{
  final CameraDescription camera;
  _Scanpage(this.camera);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
        color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text(widget.title, style: const TextStyle(color:Colors.white)),
        
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
                  MaterialPageRoute(builder: (context) => const CameraWithDynamicBox()),
                  );
            },
          child: const Text('Begin Scan',style: TextStyle(color:Colors.white)),
          ),
        ]
        ),
      ),
        bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back',style: TextStyle(color:Colors.white)),
          
        ),
      ),
    );
  }
}
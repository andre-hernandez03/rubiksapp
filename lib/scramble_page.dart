import 'package:flutter/material.dart';

//SCRAMBLE PAGE
class Scramblepage extends StatefulWidget {

  const Scramblepage({super.key, required this.title});
  final String title;

  @override
  State<Scramblepage> createState() => _Scramblepage();
}

class _Scramblepage extends State<Scramblepage> 
{
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
            },
          child: const Text('Tap to scramble',style: TextStyle(color:Colors.white)),
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
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CloudBackground(
          child: Center(
            child: Text(
              'American Sign Language Interpreter',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloudBackground extends StatelessWidget {
  final Widget child;
  const CloudBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 213, 224, 233),
        ),
        Positioned(
          top: 50,
          left: 50,
          child: Image.asset('assets/cloud1.png', width: 100, height: 100),
        ),
        Positioned(
          top: 150,
          right: 50,
          child: Image.asset('assets/cloud2.png', width: 150, height: 150),
        ),
        // Add more Positioned widgets for additional clouds
        child,
      ],
    );
  }
}

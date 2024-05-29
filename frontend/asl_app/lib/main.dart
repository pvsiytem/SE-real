import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import the camera package for live video streaming
import 'package:provider/provider.dart';
//import 'package:tflite/tflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CloudsPosition(),
      child: MaterialApp(
        title: 'ASL App',
        theme: ThemeData(
          primaryColor: Colors.lightBlue, // Set the background color to light blue
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false, // Remove the debug banner
      ),
    );
  }
}

class CloudsPosition extends ChangeNotifier {
  List<Offset> clouds = [
    Offset(100, 150),
    Offset(200, 200),
    Offset(300, 120),
    Offset(500, 450),
    Offset(600, 500),
    Offset(700, 420),
  ];

  void updateCloudPosition(int index, Offset newPosition) {
    clouds[index] = newPosition;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blue Background
          Container(
            color: Colors.lightBlue,
            width: double.infinity,
            height: double.infinity,
          ),
          // Clouds
          Clouds(),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'American Sign Language Interpreter',
                  style: TextStyle(fontSize: 24, color: Colors.white), // Adjusted font size and color
                ),
                SizedBox(height: 20), // Adds some space
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPage()),
                    );
                  },
                  child: Text('New Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter!'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8, // Set a higher flex value for the camera to make it larger
            child: CameraWidget(),
          ),
          Expanded(
            flex: 2, // Set a lower flex value for the chat column to make it shorter
            child: ChatColumn(),
          ),
        ],
      ),
    );
  }
}


class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _controller.initialize(); // Await initialization

    if (mounted) {
      setState(() {}); // Trigger rebuild if mounted
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraPreview(_controller);
  }
}


class ChatColumn extends StatefulWidget {
  @override
  _ChatColumnState createState() => _ChatColumnState();
}

class _ChatColumnState extends State<ChatColumn> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> messages = ['Do you want to learn how to sign this word?'];
  
  // Declare _sendMessage using the late keyword
  late void Function() _sendMessage = () {
    String input = _textEditingController.text.trim();
    if (input.isNotEmpty) {
      String message = 'Do you want to learn how to sign "$input"?';
      messages.add(message);
      _textEditingController.clear();
      setState(() {});
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    messages[index],
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your message here',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                  ),
                  onSubmitted: (_) => _sendMessage(), // Call _sendMessage when Enter is pressed
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _sendMessage, // Call _sendMessage when button is pressed
                child: Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class Clouds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CloudsPosition>(
      builder: (context, cloudPosition, _) {
        return Stack(
          children: cloudPosition.clouds.map((position) {
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Icon(
                Icons.cloud,
                color: Colors.white,
                size: 120,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

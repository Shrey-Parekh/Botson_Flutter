import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get the first camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera, cameras: cameras));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.camera, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CameraScreen(camera: camera, cameras: cameras),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.camera, required this.cameras});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {
      // Handle the case when the permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  void _initializeCamera() {
    // Create a CameraController to display the camera preview.
    _controller = CameraController(
      widget.cameras[currentCameraIndex],
      ResolutionPreset.high,
    );

    // Initialize the controller, which returns a Future.
    _initializeControllerFuture = _controller.initialize().then((_) {
      // Ensure the widget is rebuilt once the camera is initialized
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void switchCamera() {
    setState(() {
      currentCameraIndex = (currentCameraIndex + 1) % widget.cameras.length;
      _initializeCamera(); // Re-initialize with the new camera
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webcam Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}



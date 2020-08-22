/*import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoRecorder extends StatefulWidget {
  final CameraDescription camera;
  VideoRecorder({Key key, this.camera}) : super(key: key);

  @override
  _VideoRecorderState createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    try {
      _initializeControllerFuture = _controller.initialize();
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.videocam),
        onPressed: () {},
      ),
    );
  }
}*/

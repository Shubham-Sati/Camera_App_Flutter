import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class TakePhoto extends StatefulWidget {
  final CameraDescription camera;

  TakePhoto({Key key, this.camera}) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String videoPath;

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btn1",
            child: Icon(Icons.camera_alt),
            onPressed: !_controller.value.isRecordingVideo
                ? () async {
                    try {
                      await _initializeControllerFuture;

                      final path = join(
                        (await getExternalStorageDirectory()).path,
                        'images/${DateTime.now()}.png',
                      );

                      await _controller.takePicture(path);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DisplayPictureScreen(imagePath: path),
                          ));
                    } catch (e) {
                      print(e);
                    }
                  }
                : null,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            child: Icon(Icons.videocam),
            onPressed: !_controller.value.isRecordingVideo
                ? _onRecordButtonPressed
                : null,
          ),
          FloatingActionButton(
            heroTag: "btn3",
            child: Icon(Icons.stop),
            onPressed: _onStopButtonPressed,
          ),
        ],
      ),
    );
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording Started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    });
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      Fluttertoast.showToast(
          msg: 'Video saved to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    });
  }

  Future<String> _startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    if (_controller.value.isRecordingVideo) {
      return null;
    }

    final filePath = join(
      (await getExternalStorageDirectory()).path,
      'videos/${DateTime.now()}.mp4',
    );

    try {
      await _controller.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();

      print("here");
    } on CameraException catch (e) {
      return null;
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("path"),
      ),
      body: Text(imagePath),
    );
  }
}

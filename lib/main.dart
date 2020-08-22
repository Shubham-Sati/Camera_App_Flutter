import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:final_camera_app/imagelist.dart' as imagelist;
import 'package:final_camera_app/videolist.dart' as videolist;
import 'package:final_camera_app/takephoto.dart' as takephoto;
import 'dart:io';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  Directory(
          '/storage/emulated/0/Android/data/com.example.final_camera_app/files/images')
      .create(recursive: true);

  Directory(
          '/storage/emulated/0/Android/data/com.example.final_camera_app/files/videos')
      .create(recursive: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera app"),
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.image),
            ),
            Tab(
              icon: Icon(Icons.play_arrow),
            ),
            Tab(
              icon: Icon(Icons.camera),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          imagelist.ImageList(),
          videolist.VideoList(),
          takephoto.TakePhoto(camera: cameras[0]),
          //videorecorder.VideoRecorder(camera: cameras[0]),
        ],
      ),
    );
  }
}

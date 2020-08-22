import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class VideoList extends StatefulWidget {
  VideoList({Key key}) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  String videoDir;
  List file = List();
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    videoDir = (await getExternalStorageDirectory()).path;
    videoDir = videoDir + '/videos/';
    setState(() {
      file = io.Directory("$videoDir")
          .listSync()
          .toList(); //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (file.isEmpty) {
      return Container(
        child: Center(child: Text("Nothing to Show")),
      );
    } else {
      List<String> name = [];
      for (var i in file) {
        name.add(i.toString().substring(82, i.toString().length - 1));
      }

      return Container(
        child: ListView.builder(
          itemCount: name.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(name[index]),
            );
          },
        ),
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class ImageList extends StatefulWidget {
  ImageList({Key key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  String imageDir;
  List file = List();
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    imageDir = (await getExternalStorageDirectory()).path;
    imageDir = imageDir + '/images/';
    setState(() {
      file = io.Directory("$imageDir")
          .listSync()
          .toList(); //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (file.isEmpty) {
      return Container(
        child: Center(
          child: Text("Nothing to Show"),
        ),
      );
    } else {
      List<String> name = [];
      List<String> path = [];
      for (var i in file) {
        name.add(i.toString().substring(82, i.toString().length - 1));
        path.add(i.toString().substring(7, i.toString().length - 1));
      }

      return Container(
        child: ListView.builder(
          itemCount: name.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: (Image.file(File(path[index]))).image,
              ),
              title: Text(name[index]),
            );
          },
        ),
      );
    }
  }
}

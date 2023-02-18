import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Image Picker from Gallery"),
            backgroundColor: Colors.redAccent),
        body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 90,
              // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              alignment: Alignment.center,
              child:
                  // borderRadius: BorderRadius.circular(20),
                  // color: Colors.green[200][200],
                  TextButton.icon(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(100, 90)),
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.green[200])),
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          //update UI
                        });
                      },
                      icon: Icon(Icons.image),
                      label: Text("Pick Image")),
            ),
            Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              height: 90,
              // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              alignment: Alignment.center,

              child: TextButton.icon(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(150, 150)),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Colors.green[200])),
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      //update UI
                    });
                  },
                  icon: Icon(Icons.settings),
                  label: Text("Setting")),
            )
          ]),
        )
        // Container(
        //     padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        //     alignment: Alignment.topCenter,
        //     child: Column(
        //       children: [
        //         ElevatedButton(
        //             onPressed: () async {
        //               image =
        //                   await picker.pickImage(source: ImageSource.gallery);
        //               setState(() {
        //                 //update UI
        //               });
        //             },
        //             child: Text("Pick Image")),
        //         image == null ? Container() : Image.file(File(image!.path))
        //       ],
        //     ))
        );
  }
}

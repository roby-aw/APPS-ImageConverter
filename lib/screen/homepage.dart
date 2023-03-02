import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apps_imageconverter/screen/preview_image.dart';

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
            title: Text("Simple Converter Image"),
            backgroundColor: Colors.redAccent),
        body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 150,
              height: 80,
              // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              alignment: Alignment.center,
              child:
                  // borderRadius: BorderRadius.circular(20),
                  // color: Colors.green[200][200],
                  TextButton.icon(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(Size(1000, 1000)),
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.redAccent)),
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PreviewImage(
                                          image: image,
                                        )));
                          });
                        }
                      },
                      icon: Icon(Icons.image, color: Colors.white),
                      label: Text(
                        "Pick Image",
                        style: TextStyle(color: Colors.white),
                      )),
            ),
          ]),
        ));
  }
}

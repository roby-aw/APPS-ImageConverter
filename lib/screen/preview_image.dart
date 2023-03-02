import 'dart:io';
import 'package:flutter/material.dart';
import 'package:apps_imageconverter/screen/download_image.dart';
import 'package:apps_imageconverter/network/convert.dart';
import 'package:image_picker/image_picker.dart';

class PreviewImage extends StatefulWidget {
  XFile? image;

  PreviewImage({Key? key, this.image}) : super(key: key);
  @override
  _PreviewImageState createState() => _PreviewImageState();
}

const List<String> list = <String>['png', 'jpg', 'webp'];

class _PreviewImageState extends State<PreviewImage> {
  double _currentSliderValue = 20;
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Simple Converter Image"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: _buildTitleSection(title: "Preview Image", subTitle: ""),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Container(
                    child: ClipRRect(
                  child: Image.file(
                    File(widget.image!.path),
                    fit: BoxFit.contain,
                  ),
                )),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Image Format : "),
                      DropdownButton(
                          value: dropdownValue,
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          }),
                    ],
                  ),
                ),
                Text("Image Quality: ${_currentSliderValue.round()}%"),
                Slider(
                    value: _currentSliderValue,
                    max: 100,
                    min: 5,
                    divisions: 19,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    }),
                Padding(
                    padding: EdgeInsets.only(left: 250, right: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.redAccent)),
                          onPressed: () async {
                            var reqConvert = ReqConvert(
                                Type: dropdownValue,
                                Quality: _currentSliderValue.round(),
                                img: File(widget.image!.path));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DownloadImage(
                                        reqConvert: reqConvert,
                                      )),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.navigate_next),
                              Text("Convert"),
                            ],
                          )),
                    )),
              ]),
            )

            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Card(
            //     elevation: 5,
            //     child: Container(
            //       padding: EdgeInsets.all(8),
            //       child: _buildTitleSection(
            //           title: 'Image Preview', subTitle: 'Image'),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Expanded(
            //     child: Container(
            //       child: Image.file(File(widget.image!.path)),
            //     ),
            //   ),
            // ),
          ],
        ));
  }

  Column _buildTitleSection({@required title, @required subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

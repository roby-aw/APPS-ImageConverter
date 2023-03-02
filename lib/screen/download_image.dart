import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:apps_imageconverter/network/convert.dart';
import 'package:apps_imageconverter/screen/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DownloadImage extends StatefulWidget {
  ReqConvert reqConvert;

  DownloadImage({Key? key, required this.reqConvert}) : super(key: key);
  @override
  _DownloadImageState createState() =>
      _DownloadImageState(reqConvert: reqConvert);
}

class _DownloadImageState extends State<DownloadImage> {
  ReqConvert reqConvert;
  bool _isLoading = false;
  _DownloadImageState({Key? key, required this.reqConvert});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Simple Converter Image"),
          backgroundColor: Colors.redAccent,
        ),
        // Page Download
        body: FutureBuilder<dynamic>(
            future: sendConvert(reqConvert, context),
            builder: (context, snapshot) {
              if (_isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              var id = snapshot.data['result']['image'];
                              await getImageByID(id, context).then((value) {
                                _getHttp(value['result']['filename'],
                                    value['result']['image'], context);
                              });

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SuccessPage(
                                          filename: snapshot.data['result']
                                              ['filename'])));
                            },
                            child: Text(
                              "Download Image",
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            }));
  }
}

_getHttp(String filename, String img, BuildContext context) async {
  String path;
  Directory? rootPath;
  bool permission = await requestPermission();
  if (Platform.isAndroid) {
    if (permission) {
      var directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      String convertedDirectoryPath = (directory?.path).toString();
      List<String> paths = convertedDirectoryPath.split("/");
      for (int x = 1; x < convertedDirectoryPath.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      path = newPath;
    } else {
      print("permssion denied");
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Please give neccesary permissions");
      return false;
    }
  } else {
    path = '/storage/emulated/0';
  }

  if (path == null) {
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: "Please give neccesary permissions");
    return false;
  }

  path = "${path}/Download/${filename}";
  var res = base64Decode(img);
  File file2 = await File(path);
  await file2.writeAsBytes(res);
}

class FileImg {
  late String name;
  late String ext;

  FileImg({required this.name, required this.ext});
}

Future<bool> requestPermission() async {
  bool storagePermission = await Permission.storage.isGranted;
  bool mediaPermission = await Permission.accessMediaLocation.isGranted;

  if (!storagePermission) {
    storagePermission = await Permission.storage.request().isGranted;
  }

  if (!mediaPermission) {
    mediaPermission = await Permission.accessMediaLocation.request().isGranted;
  }

  bool isPermissionGranted = storagePermission && mediaPermission;

  if (isPermissionGranted) {
    return true;
  } else {
    return false;
  }
}

getImageByID(String id, BuildContext context) async {
  print("Get Image By ID");
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token')!;
  var url = Uri.parse(
      'https://api-imageconverter-production.up.railway.app/v1/image/' + id);
  var response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

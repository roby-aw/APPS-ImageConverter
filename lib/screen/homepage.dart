import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apps_imageconverter/screen/preview_image.dart';
import 'package:apps_imageconverter/screen/download_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer' as developer;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImagePicker picker = ImagePicker();
  XFile? image;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late Future<bool> _req = requestPermission();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _req;

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.

    result = await _connectivity.checkConnectivity();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.none) {
        Fluttertoast.showToast(
            msg: "Please Check Your Connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

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
                        if (_connectionStatus == ConnectivityResult.none) {
                          Fluttertoast.showToast(
                              msg: "Please Check Your Connection",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          _req.then((value) async {
                            if (value) {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
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
                            } else {
                              _req;
                              Fluttertoast.showToast(
                                  msg: "Please give neccesary permissions");
                            }
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

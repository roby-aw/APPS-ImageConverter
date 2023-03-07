import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apps_imageconverter/screen/homepage.dart';
import 'package:apps_imageconverter/network/token.dart';

class SPlashScreen extends StatefulWidget {
  const SPlashScreen({Key? key}) : super(key: key);
  @override
  _SPlashScreenState createState() => _SPlashScreenState();
}

class _SPlashScreenState extends State<SPlashScreen> {
  @override
  void initState() {
    super.initState();

    // checkLogin();
    const delay = Duration(seconds: 2);
    Future.delayed(delay, () => _loadFromPrefs());
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      getToken();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      getToken();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  height: double.infinity,
                  width: double.infinity,
                  child: Image(
                      image: Image.asset(
                    "assets/image/splash.jpg",
                    fit: BoxFit.contain,
                  ).image)))
        ],
      ),
    );
  }
}

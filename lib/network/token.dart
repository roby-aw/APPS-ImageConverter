import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

getToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(
        "https://api-imageconverter-production.up.railway.app/v1/user/login");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"username": "eCLEe0nBXb", "password": "aKBosEzzWU"}),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      prefs.setString('token', result['result']['token']['access_token']);
    } else {
      Fluttertoast.showToast(msg: "Error Fetch Code");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error Fetch");
  }
}

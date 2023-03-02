import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:apps_imageconverter/network/token.dart';
import 'package:apps_imageconverter/screen/homepage.dart';

class ReqConvert {
  final String Type;
  final int Quality;
  final File img;

  ReqConvert({required this.Type, required this.Quality, required this.img});
}

sendConvert(reqConvert, context) async {
  var prefs = await SharedPreferences.getInstance();
  var request = http.MultipartRequest(
      "POST",
      Uri.parse(
          "https://api-imageconverter-production.up.railway.app/v1/image/convert"));
  request.fields["type_convert"] = "." + reqConvert.Type.toString();
  request.fields["quality"] = reqConvert.Quality.toString();
  request.files
      .add(await http.MultipartFile.fromPath("image", reqConvert.img.path));
  request.headers.addAll({
    "Content-Type": "multipart/form-data",
    "Authorization": "Bearer " + prefs.getString('token').toString(),
  });
  var result = await request.send();
  var responseData = await result.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  if (result.statusCode != 200) {
    if (responseString.contains("invalid token")) {
      await getToken();
      sendConvert(reqConvert, context);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  } else {
    var data = jsonDecode(responseString);
    print(data);
    return data;
  }
}

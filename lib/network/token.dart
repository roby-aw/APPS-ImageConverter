import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

getToken() async {
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
    print('Request failed with status: ${response.statusCode}.');
  }
}

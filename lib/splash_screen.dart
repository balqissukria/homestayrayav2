import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'user.dart';
import 'homescreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("HOMESTAY RAYA",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                Text("Version 2.0",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))
              ]),
        ),
        backgroundColor: Colors.brown);
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _pass = (prefs.getString('pass')) ?? '';
    if (_email.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/php/login_user.php"),
          body: {"email": _email, "password": _pass}).then((response) {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          //var jsonResponse = json.decode(response.body);
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Homescreen(user: user))));
        } else {
          User user = User(
            id: "0",
            email: "unregistered",
            name: "unregistered",
            address: "na",
            phone: "0123456789",
          );
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Homescreen(user: user))));
        }
      });
    } else {
      User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
      );
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => Homescreen(user: user))));
    }
  }
}

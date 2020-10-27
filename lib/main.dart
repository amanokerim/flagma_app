import 'package:flagma_app/const.dart';
import 'package:flagma_app/screens/login_screen.dart';
import 'package:flagma_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/loading.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flagma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: myPrimaryColor,
      ),
      home: InitPage(),
    );
  }
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Widget display = Loading();

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        display = MainScreen(ln: value[1], token: value[0]);
      });
    });
    super.initState();
  }

  Future<dynamic> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString("token") ?? "", prefs.getString("ln") ?? "tm"];
  }

  @override
  Widget build(BuildContext context) {
    return display;
  }
}

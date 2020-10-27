import 'package:flutter/material.dart';
import '../widgets/logo_bar.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  final String ln;

  LoginScreen({this.ln});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          LogoBar(logo: "Flagma"),
          LoginForm(ln: widget.ln),
        ],
      ),
    );
  }
}

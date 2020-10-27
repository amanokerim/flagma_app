import 'package:flutter/material.dart';
import '../widgets/logo_bar.dart';
import '../widgets/registration_form.dart';

class RegisterScreen extends StatelessWidget {
  final String ln;
  RegisterScreen({this.ln});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            LogoBar(logo: "Flagma"),
            RegistrationForm(ln: ln),
          ],
        ),
      ),
    );
  }
}

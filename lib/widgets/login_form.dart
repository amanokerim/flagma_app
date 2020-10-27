import 'dart:convert';

import 'package:flagma_app/screens/loading.dart';
import 'package:flagma_app/screens/main_screen.dart';
import 'package:flagma_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../lang.dart';
import 'super_lite_button.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  final String ln;

  const LoginForm({
    Key key,
    this.ln,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController, _passwordController;
  String errorText = "";
  bool isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  void loginFunction() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await http.get(
          "https://api.flagma.biz/api/get_account?email=${_emailController.text}&password=${_passwordController.text}");

      var resMap = jsonDecode(res.body);
      print(resMap);
      if (res.statusCode == 200) {
        String token = resMap["token"];
        if (token != null && token.isNotEmpty) {
          setSPString("token", token);
          setSPString("contact_id", resMap["id"].toString());
          setSPString("email", _emailController.text);
          setSPString("password", _passwordController.text);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MainScreen(ln: widget.ln, token: token),
            ),
          );
        }
      } else {
        setState(() {
          isLoading = false;
          errorText = resMap["code_tm"];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorText = lang["check_connection"][widget.ln];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: isLoading
          ? loading
          : Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lang["login"][widget.ln],
                    style: myH3,
                  ),
                  errorText == null || errorText.isEmpty
                      ? Container()
                      : Text(errorText,
                          style: myH5.copyWith(color: Colors.red)),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: lang["password"][widget.ln],
                    ),
                    obscureText: true,
                    onEditingComplete: loginFunction,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FlatButton(
                      onPressed: loginFunction,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                      child: Text(lang["login"][widget.ln],
                          style: TextStyle(color: Colors.white)),
                      color: myPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(width: 120, height: .5, color: myDarkColor),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(lang["or"][widget.ln], style: myT1),
                      ),
                      Container(width: 120, height: .5, color: myDarkColor),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(lang["dont_have_account"][widget.ln], style: myT1),
                      SizedBox(width: 20),
                      SuperLiteButton(
                          title: lang["register"][widget.ln],
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(
                                  ln: widget.ln,
                                ),
                              ),
                            );
                          }),
                      SizedBox(width: 50),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(lang["forgot_password"][widget.ln], style: myT1),
                      SizedBox(width: 20),
                      SuperLiteButton(
                          title: lang["reset"][widget.ln], onTap: () {}),
                      SizedBox(width: 50),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

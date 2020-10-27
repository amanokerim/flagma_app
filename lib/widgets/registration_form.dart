import 'dart:convert';

import 'package:flagma_app/screens/main_screen.dart';
import 'package:flagma_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../lang.dart';
import 'super_lite_button.dart';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  final String ln;

  const RegistrationForm({
    Key key,
    this.ln,
  }) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

bool verificationSent = false;

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController,
      _passwordController,
      _passwordController2,
      _verificationCodeController;
  String errorText = "";
  bool isLoading = false;

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _passwordController2 = new TextEditingController();
    _verificationCodeController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  lang["register"][widget.ln],
                  style: myH3,
                ),
                errorText == null || errorText.isEmpty
                    ? Container()
                    : Text(errorText, style: myH5.copyWith(color: Colors.red)),
                !verificationSent
                    ? TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: lang["mail"][widget.ln],
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )
                    : Container(),
                verificationSent
                    ? TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          print(value);
                          if (value.length < 8)
                            return lang["more_than_8"][widget.ln];
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: lang["password"][widget.ln],
                          hintText: lang["min_8_symbols"][widget.ln],
                        ),
                        obscureText: true,
                      )
                    : Container(),
                verificationSent
                    ? TextFormField(
                        controller: _passwordController2,
                        validator: (value) {
                          if (_passwordController.text != value)
                            return lang["passwords_not_match"][widget.ln];
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: lang["repeat_password"][widget.ln],
                          hintText: lang["same_with_first_pass"][widget.ln],
                        ),
                        obscureText: true,
                      )
                    : Container(),
                verificationSent
                    ? TextFormField(
                        controller: _verificationCodeController,
                        validator: (value) {
                          if (value.length != 4)
                            return lang["code_4_symbols"][widget.ln];
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: lang["verification_code"][widget.ln],
                          hintText: lang["code_from_your_email"][widget.ln],
                        ),
                        keyboardType: TextInputType.number,
                      )
                    : Container(),
                SizedBox(height: 20),
                verificationSent
                    ? FlatButton(
                        child: Text(lang["another_email"][widget.ln]),
                        onPressed: () {
                          setState(() {
                            //Clear all fields
                            _emailController.clear();
                            _passwordController.clear();
                            _passwordController2.clear();
                            _verificationCodeController.clear();
                            errorText = "";
                            //And show email field
                            verificationSent = false;
                          });
                        },
                      )
                    : Container(),
                Center(
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        errorText = "";
                      });
                      if (verificationSent == false) {
                        // Verification is not sent yet. Send verification code to given email. If success set
                        // verificationSent as true
                        try {
                          var res = await http.post(
                            "https://api.flagma.biz/api/start_verification",
                            body: {"email": _emailController.text},
                          );
                          print("Sending verif:       " + res.body);
                          if (res.statusCode == 200 &&
                              jsonDecode(res.body)["type"] == "success") {
                            setState(
                              () {
                                verificationSent = true;
                              },
                            );
                          } else {
                            setState(() {
                              errorText =
                                  jsonDecode(res.body)["code_" + widget.ln];
                              isLoading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            errorText = lang["check_connection"][widget.ln];
                            isLoading = false;
                          });
                        }
                      } else {
                        // Verification already sent and pressed Register button
                        // Register new account
                        // Navigate to profile update screen
                        if (_formKey.currentState.validate())
                          try {
                            var res = await http.post(
                                "https://api.flagma.biz/api/add_account",
                                body: {
                                  "email": _emailController.text,
                                  "password": _passwordController.text,
                                  "code": _verificationCodeController.text,
                                });
                            // print("Adding account");
                            // print(res.statusCode);
                            // print(res.body);
                            if (res.statusCode == 200) {
                              var resMap = jsonDecode(res.body);

                              setSPString("token", resMap["token"]);
                              setSPString(
                                  "contact_id", resMap["id"].toString());

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                      ln: widget.ln, token: resMap["token"]),
                                ),
                              );
                            } else {
                              setState(() {
                                errorText =
                                    jsonDecode(res.body)["code_" + widget.ln];
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorText = lang["check_connection"][widget.ln];
                              isLoading = false;
                            });
                          }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                    child: Text(
                        verificationSent == false
                            ? lang["send_verification_code"][widget.ln]
                            : lang["register"][widget.ln],
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
                HaveAccountRow(ln: widget.ln),
              ],
            ),
          ),
          isLoading ? loading : Container(),
        ],
      ),
    );
  }
}

class HaveAccountRow extends StatelessWidget {
  final String ln;
  const HaveAccountRow({
    Key key,
    this.ln,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(lang["have_account"][ln], style: myT1),
        SizedBox(width: 20),
        SuperLiteButton(
            title: lang["login"][ln],
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen(ln: ln)));
            }),
        SizedBox(width: 50),
      ],
    );
  }
}

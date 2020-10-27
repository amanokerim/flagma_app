import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lang.dart';

// Colors
const Color myPrimaryColor = Color(0xFF2b3d61);
const Color myDarkColor = Color(0xFF444444);
const Color myGreyColor = Color(0xFF737373);
// const MaterialColor myP = MaterialColor(0x)

// Text styles
const TextStyle myH3 =
    TextStyle(fontSize: 22, color: myDarkColor, fontWeight: FontWeight.bold);
const TextStyle myH4 =
    TextStyle(fontSize: 20, color: myDarkColor, fontWeight: FontWeight.bold);
const TextStyle myH5 =
    TextStyle(fontSize: 16, color: myDarkColor, fontWeight: FontWeight.bold);

const TextStyle myT1 = TextStyle(color: myDarkColor);

const TextStyle mySub0 = TextStyle(color: myGreyColor, fontSize: 16);
const TextStyle mySub = TextStyle(color: myGreyColor);
const TextStyle mySub2 = TextStyle(color: myGreyColor, fontSize: 12);

const TextStyle myH5White =
    TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    launch(url);
  } else {
    throw "Could not launch $url";
  }
}

Widget myUnderline = Container(
  decoration: BoxDecoration(
    border: Border.all(color: myGreyColor, width: .4),
  ),
);

BoxDecoration myLanguageIconSelectedDecoration = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    color: Colors.white54,
    width: 1.0,
  ),
);

const myFilterInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  ),
);

List<String> types = [
  "Product",
  "Service",
];

Future<String> getSPString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? "";
}

Widget loading = Center(child: SpinKitCubeGrid(color: myPrimaryColor));

Widget refreshButton(Function action, String ln) {
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          lang["check_connection"][ln],
          style: myH5,
        ),
        SizedBox(height: 10),
        Text(lang["and_or"][ln], style: mySub),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: myDarkColor,
          ),
          onPressed: action,
          iconSize: 70,
        ),
      ],
    ),
  );
}

void setSPString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

String firstUpper(String s) {
  return s[0].toUpperCase() + s.substring(1);
}

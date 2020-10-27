import 'package:flutter/material.dart';

import '../const.dart';
import '../lang.dart';

class SuperBottomNavigationBar extends StatelessWidget {
  final Function tabChanger;
  final int selectedIndex;
  final String ln;

  const SuperBottomNavigationBar({
    Key key,
    this.tabChanger,
    this.selectedIndex,
    this.ln,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyBottomNavigationBarClipper(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: myPrimaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton.icon(
              padding: EdgeInsets.symmetric(vertical: 10),
              onPressed: () {
                tabChanger(0);
              },
              icon: Icon(
                Icons.category,
                color: selectedIndex == 0 ? Colors.white : Colors.white70,
              ),
              label: Text(
                lang["products"][ln],
                style: TextStyle(
                  color: selectedIndex == 0 ? Colors.white : Colors.white70,
                ),
              ),
            ),
            FlatButton.icon(
              padding: EdgeInsets.symmetric(vertical: 10),
              onPressed: () {
                tabChanger(1);
              },
              icon: Icon(Icons.chat,
                  color: selectedIndex == 1 ? Colors.white : Colors.white70),
              label: Text(
                lang["chats"][ln],
                style: TextStyle(
                  color: selectedIndex == 1 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomNavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double sz = 20;
    path.moveTo(0, sz / 2);
    path.lineTo(sz, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, sz / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

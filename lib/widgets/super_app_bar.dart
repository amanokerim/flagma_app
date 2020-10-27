import 'package:flutter/material.dart';

import '../const.dart';

class SuperAppBar extends StatelessWidget {
  final List<Widget> children;
  const SuperAppBar({
    Key key,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
          height: 100,
          decoration: BoxDecoration(color: myPrimaryColor),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 8),
            child: Row(
              children: children,
            ),
          )),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double sz = 20;
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - sz / 2);
    path.lineTo(sz, size.height - sz / 2);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

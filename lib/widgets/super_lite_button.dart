import 'package:flutter/material.dart';

import '../const.dart';

class SuperLiteButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const SuperLiteButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: myPrimaryColor),
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
    );
  }
}

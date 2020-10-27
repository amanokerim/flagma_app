import 'package:flutter/material.dart';

import '../const.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool toMe;

  const ChatMessage({
    Key key,
    @required this.text,
    @required this.toMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: toMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        alignment: Alignment.centerLeft,
        // height: 30,
        width: 250,
        margin: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: toMe ? Colors.blue : Color(0xFFDDDDDD),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomRight: toMe ? Radius.circular(10.0) : Radius.zero,
            bottomLeft: !toMe ? Radius.circular(10.0) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: toMe ? Colors.white : myDarkColor,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

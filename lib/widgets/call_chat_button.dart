import 'package:flutter/material.dart';

import '../const.dart';
import '../lang.dart';

class CallChatButton extends StatelessWidget {
  final String mailUrl, callUrl, ln;

  const CallChatButton({
    Key key,
    @required this.mailUrl,
    @required this.callUrl,
    this.ln,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sz = MediaQuery.of(context).size.width / 3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => launchUrl(callUrl),
          child: Container(
            height: 60,
            width: sz,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                topLeft: Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                SizedBox(width: 5.0),
                Text(lang["call"][ln],
                    style: myH5.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => launchUrl(mailUrl),
          child: Container(
            height: 60,
            width: sz,
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                SizedBox(width: 5.0),
                Text(
                  lang["mail"][ln],
                  style: myH5.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   height: 60,
        //   padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   decoration: BoxDecoration(
        //     color: Colors.amber,
        //     borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(5.0),
        //       topRight: Radius.circular(5.0),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Icon(
        //         Icons.message,
        //         color: Colors.white,
        //       ),
        //       SizedBox(width: 5.0),
        //       Text(
        //         lang["chat"][ln],
        //         style: myH5.copyWith(color: Colors.white),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

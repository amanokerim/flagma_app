import 'package:flutter/material.dart';

import '../const.dart';
import '../widgets/super_app_bar.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  final int newMessages;

  ChatScreen({@required this.name, this.newMessages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SuperAppBar(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                newMessages == null ? name : name + " ($newMessages)",
                style: myH4.copyWith(color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ChatMessage(
                  text: "Salam gowymy?",
                  toMe: true,
                ),
                ChatMessage(
                  text: "Salam, Hudaya shukur. Siz gowy?",
                  toMe: false,
                ),
                ChatMessage(
                  text: "Shukur Hudaya.",
                  toMe: true,
                ),
                ChatMessage(
                  text: "Bold-y 10000-den kop alsan nacheden chykyarka?",
                  toMe: true,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "New message(s)",
                    style: myH5,
                  ),
                ),
                SizedBox(height: 20),
                ChatMessage(
                  text: "4.60 manatdan",
                  toMe: false,
                ),
                ChatMessage(
                  text: "Turkmenistanyn islendik nokadyna mugt ertip beryaris",
                  toMe: false,
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 70.0,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: myPrimaryColor),
                  // color: Colors.yellow,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, size: 30),
              color: myPrimaryColor,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

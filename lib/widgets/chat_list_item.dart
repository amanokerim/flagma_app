import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../screens/chat_screen.dart';

class ChatListItem extends StatelessWidget {
  final String name, lastSeen;
  final int newMessages;

  const ChatListItem({
    Key key,
    @required this.name,
    this.lastSeen,
    this.newMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => ChatScreen(
              name: name,
              newMessages: newMessages,
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(
          name,
          style: myH5,
        ),
        subtitle: lastSeen != null ? Text(lastSeen) : null,
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(name.substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: 20)),
        ),
        trailing: newMessages != null
            ? Container(
                height: 25,
                width: 25,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(
                    child: Text(newMessages.toString(),
                        style: TextStyle(color: Colors.white))),
              )
            : Container(width: 1),
      ),
    );
  }
}

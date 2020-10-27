import 'package:flutter/material.dart';

import 'chat_list_item.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        ChatListItem(
          name: "Yupekchi",
          lastSeen: "2 hours ago",
          newMessages: 2,
        ),
        ChatListItem(
          name: "Kerim Amanov",
          lastSeen: "12 minutes ago",
          newMessages: 3,
        ),
        ChatListItem(
          name: "Taze Ay",
          lastSeen: "1 day ago",
        ),
        ChatListItem(
          name: "Palma",
          lastSeen: "1 week ago",
        ),
        ChatListItem(
          name: "Hasar",
          lastSeen: "3 weeks ago",
        ),
        ChatListItem(
          name: "Ak Yol",
          lastSeen: "1 month ago",
        ),
      ],
    );
  }
}

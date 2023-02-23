import 'package:flutter/material.dart';

import '../main.dart';

class Overdue extends StatefulWidget {
  const Overdue({Key? key}) : super(key: key);

  @override
  State<Overdue> createState() => _OverdueState();
}

class _OverdueState extends State<Overdue> {
  String _lastMessage = "";

  myHomePageState() {
    messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification message:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body},'
              '\nData=${message.data}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Last message from Firebase Messaging:',
                style: Theme.of(context).textTheme.titleMedium),
            Text(_lastMessage, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

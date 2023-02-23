import 'package:flutter/material.dart';
import 'package:my_task/screen/pending.dart';

import 'completed.dart';
import 'overdue.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Overdue'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Pending(),
            Overdue(),
            Completed(),
          ],
        ),
      ),
    );
  }
}

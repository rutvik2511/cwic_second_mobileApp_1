import 'package:flutter/material.dart';

import '../database.dart';
import 'add_data.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  List<Map<dynamic, dynamic>> pendingList = [];
  MyDatabase db = MyDatabase();



  @override
  void initState() {
    pendingList = pendingList.reversed.toList();
    db.open();
    getData();
    refreshData();
    setState(() {});
    super.initState();
  }

  getData() {
    db.db?.rawQuery('SELECT * FROM pending').then((value) {
      setState(() {
        pendingList = value;
      });
    });
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    getData();
  }

  // void moveToCompletedScreen(Map<dynamic, dynamic> taskDetails) async {
  //   await db.db.transaction((txn) async {
  //     await txn.rawInsert('INSERT INTO completed (title,description, amount, deadline) VALUES(?, ?, ?, ?)',
  //         [taskDetails['title'],taskDetails['description'], taskDetails['amount'], taskDetails['deadline']]);
  //     await txn.rawDelete('DELETE FROM pending WHERE title = ?', [taskDetails['title']]);
  //   });
  //   setState(() {
  //     pendingList.remove(taskDetails);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: (pendingList.isEmpty)
            ? Center(
                child: Text(
                  "NO DATA TO SHOW",
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: pendingList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8, left: 8, top: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "From :- ",
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  pendingList[index]["title"],
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Amount :- ",
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  pendingList[index]["amount"],
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Due Date :- ",
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  pendingList[index]["deadline"],
                                  style: TextStyle(
                                    fontSize: size.width * 0.037,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                await db.db?.rawDelete(
                                  "DELETE FROM pending WHERE title = ?",
                                  [pendingList[index]["title"]],
                                );
                                getData();
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () async{
                               await db.db?.rawInsert(
                                    "INSERT INTO completed(title, description, amount, deadline) VALUES (?, ?, ?, ?);",
                                    [
                                      pendingList[index]["title"],
                                      pendingList[index]["description"],
                                      pendingList[index]["amount"],
                                      pendingList[index]["deadline"]
                                    ]);
                               await db.db?.rawDelete(
                                 "DELETE FROM pending WHERE title = ?",
                                 [pendingList[index]["title"]],
                               );
                               getData();
                              },
                              icon: const Icon(Icons.forward),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDataScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../database.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  List<Map<dynamic, dynamic>> completedList = [];
  MyDatabase db = MyDatabase();

  @override
  void initState() {
    db.open();
    getData();
    refreshData();
    super.initState();
  }

  getData() {
    db.db?.rawQuery('SELECT * FROM completed').then((value) {
      setState(() {
        completedList = value;
      });
    });
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 10));
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: (completedList.isEmpty)
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
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 8, left: 8, top: 12),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                color: Colors.white
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
                            completedList[index]["title"],
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
                            completedList[index]["amount"],
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
                            completedList[index]["deadline"],
                            style: TextStyle(
                              fontSize: size.width * 0.037,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Image.asset("assets/images/completed.png",height: 70,width: 100,),
                ],
              ),
            );
          }),
    );
  }
}

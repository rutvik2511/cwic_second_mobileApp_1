import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../database.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController dueDate = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  MyDatabase db = MyDatabase();

  @override
  void initState() {
    db.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autocorrect: false,
              controller: title,
              decoration: const InputDecoration(
                hintText: ' Enter Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              autocorrect: false,
              controller: description,
              decoration: const InputDecoration(
                hintText: ' Enter Description',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              autocorrect: false,
              controller: amount,
              decoration: const InputDecoration(
                hintText: ' Enter Amount',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16.0),
            TextField(
              autocorrect: false,
              readOnly: true,
              onTap: () {
                showDatePick();
              },
              controller: dueDate,
              decoration: const InputDecoration(
                hintText: ' Select Due Date',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      saveData(db);
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDatePick() async {
    DateTime? pickedDate = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: Container(child: child),
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      dueDate.text = formattedDate;
    }
  }

  saveData(MyDatabase db) {
    if (title.text.isNotEmpty == true &&
        description.text.isNotEmpty == true &&
        amount.text.isNotEmpty == true &&
        dueDate.text.isNotEmpty == true) {
      db.db?.rawInsert(
          "INSERT INTO pending(title, description, amount, deadline) VALUES (?, ?, ?, ?);",
          [
            title.value.text.trim(),
            description.value.text.trim(),
            amount.value.text.trim(),
            dueDate.value.text.trim(),
          ]);
      Navigator.pop(context);

      title.text = "";
      description.text = "";
      amount.text = "";
      dueDate.text = "";
    } else {
      Get.snackbar("Error", "Please fill all details");
    }
  }
}

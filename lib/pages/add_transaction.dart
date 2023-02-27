import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_coffer/controllers/db_helper.dart';
import 'package:my_coffer/static.dart' as Static;

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int? amount;
  String note = "Some expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 1),
        lastDate: DateTime(2100, 1));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "Add Transaction",
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.currency_rupee,
                    size: 24.0,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: "0", border: InputBorder.none),
                  style: TextStyle(fontSize: 24.0),
                  onChanged: (val) {
                    try {
                      amount = int.parse(val);
                    } catch (e) {}
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.description,
                    size: 24.0,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Note on Transaction",
                      border: InputBorder.none),
                  style: TextStyle(fontSize: 24.0),
                  onChanged: (val) {
                    note = val;
                  },
                  maxLength: 24,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(
                    12.0,
                  ),
                  child: Icon(
                    Icons.moving_sharp,
                    size: 24.0,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: type == "Income"
                        ? Colors.white
                        : Color.fromARGB(255, 52, 51, 51),
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == "Income" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Income";
                    });
                  }
                },
              ),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text(
                  "Expense",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: type == "Expense"
                        ? Colors.white
                        : Color.fromARGB(255, 52, 51, 51),
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == "Expense" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Expense";
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 50.0,
              child: TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Static.PrimaryColor,
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: EdgeInsets.all(
                            12.0,
                          ),
                          child: Icon(
                            Icons.date_range,
                            size: 24.0,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        "${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ))),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: () async {
                  // print(amount);
                  // print(note);
                  // print(type);
                  // print(selectedDate);
                  if (amount != null && note.isNotEmpty) {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.addData(amount!, selectedDate, note, type);
                    Navigator.of(context).pop();
                  } else {
                    print("Not all values Provided!");
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}

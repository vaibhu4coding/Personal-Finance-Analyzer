import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_coffer/controllers/db_helper.dart';
import 'package:my_coffer/modals/transaction_modal.dart';
import 'package:my_coffer/pages/add_transaction.dart';
import 'package:my_coffer/static.dart' as Static;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  late SharedPreferences preferences;
  late Box box;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  int threshold = 0;
  // totalBalance = dbHelper.getIncome();

  List<FlSpot> dataSet = [];
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
  List<FlSpot> getPlotpoints(List<TransactionModel> entireData) {
    dataSet = [];
    List tempDataSet = [];

    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == "Expense") {
        tempDataSet.add(data);
      }
    }
    tempDataSet.sort(((a, b) => a.date.day.compareTo(b.date.day)));
    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(FlSpot(tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble()));
    }
    return dataSet;
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalIncome = 0;
    totalExpense = 0;
    totalBalance = 0;
    String? temp = preferences.getString('income');
    totalBalance = int.parse(temp!);
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  getpreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(TransactionModel(element['amount'] as int,
            element['date'] as DateTime, element['note'], element['type']));
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getpreference();
    box = Hive.box('money');
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTransaction()))
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Static.PrimaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Unexpected Error !"),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("No Values Found !"),
                );
              }
            }
            getTotalBalance(snapshot.data!);
            getPlotpoints(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.transparent,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "assets/images/profile_picture.png",
                              height: 50,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Welcome ${preferences.getString('name')} !",
                            style: TextStyle(
                                fontSize: 21.0,
                                color: Color.fromARGB(228, 0, 0, 0)),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.all(12.0),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Static.PrimaryColor,
                          Color.fromRGBO(72, 164, 247, 1)
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "Rs. ${totalBalance}",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(totalIncome.toString()),
                              cardExpense(totalExpense.toString())
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                          //  child: Text("data"),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Expenses",
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    showMsg(),
                  ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ]),
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
                  margin: EdgeInsets.all(12.0),
                  height: 400.0,
                  child: LineChart(LineChartData(
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                            spots: getPlotpoints(snapshot.data!),
                            isCurved: false,
                            barWidth: 2.5,
                            color: Static.PrimaryColor),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    TransactionModel dataAtIndex = snapshot.data![index];

                    if (dataAtIndex.type == "Income") {
                      return incomeTile(dataAtIndex.amount, dataAtIndex.note,
                          dataAtIndex.date, index);
                    } else {
                      return expenseTile(dataAtIndex.amount, dataAtIndex.note,
                          dataAtIndex.date, index);
                    }
                    ;
                  },
                ),
                SizedBox(
                  height: 60.0,
                )
              ],
            );
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(20.0)),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            color: Color.fromARGB(255, 51, 224, 16),
            size: 28.0,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(20.0)),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            color: Color.fromARGB(255, 224, 16, 16),
            size: 28.0,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        )
      ],
    );
  }

  Widget showMsg() {
    String? temp1 = preferences.getString('threshold');
    threshold = int.parse(temp1!);
    if (threshold > totalBalance) {
      return Text(
        'Minimize the Expense',
        style: TextStyle(
            color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.w500),
      );
    }
    return Text(
      'Well done!',
      style: TextStyle(
          color: Color.fromARGB(255, 24, 185, 18),
          fontSize: 20.0,
          fontWeight: FontWeight.w500),
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Record"),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('WARNING! , Do you like to delete the record?'),
                      // Text('Would you like to confirm this message?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      dbHelper.deleteData(index);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              color: Color(0xffced4eb),
              borderRadius: BorderRadius.circular(
                8.0,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 28.0,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Expense",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "${date.day} ${months[date.month - 1]} ${date.year}",
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "- $value",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Record"),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('WARNING! , Do you like to delete the record?'),
                      // Text('Would you like to confirm this message?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      dbHelper.deleteData(index);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              color: Color(0xffced4eb),
              borderRadius: BorderRadius.circular(
                8.0,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_circle_down_outlined,
                        size: 28.0,
                        color: Colors.green[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Income",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "${date.day} ${months[date.month - 1]} ${date.year}",
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "+ $value",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

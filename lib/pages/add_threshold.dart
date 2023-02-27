import 'package:flutter/material.dart';
import 'package:my_coffer/controllers/db_helper.dart';
import 'package:my_coffer/pages/homepage.dart';

class AddThreshold extends StatefulWidget {
  const AddThreshold({Key? key}) : super(key: key);

  @override
  State<AddThreshold> createState() => _AddThresholdState();
}

class _AddThresholdState extends State<AddThreshold> {
  String threshold = "";
  //
  DbHelper dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Analyze Your Coffer...",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(179, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12.0)),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  "assets/images/Logo.png",
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              "Enter Threshold Value",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(207, 217, 173, 209),
                  borderRadius: BorderRadius.circular(12.0)),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter Threshold Value",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                ),
                onChanged: (val) {
                  threshold = val;
                },
              ),
            ),
            SizedBox(height: 12.0),
            SizedBox(
              height: 50.0,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  //check if there is a valid name
                  if (threshold.isNotEmpty) {
                    // add to database
                    // move to the homepage
                    dbHelper.addThreshold(threshold);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  } else {
                    //show some error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          label: "ok",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.white,
                        content: Text(
                          "Please Enter Your Threshold",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  } //ek min thamb
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Icon(
                      Icons.navigate_next_rounded,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} //ab kr
//  will ask use for their name here

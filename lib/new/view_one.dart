import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class view_one extends StatefulWidget {
  const view_one({super.key});

  @override
  State<view_one> createState() => _view_oneState();
}

class _view_oneState extends State<view_one> {
  var rollval = TextEditingController();
  String roll = ' ';
  String cla = ' ';
  String name = ' ';
  var l = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String rno) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('students').doc(rno).get();
    return documentSnapshot;
  }

  // view(String rno) async {
  // }
  _showDocumentData(String rno) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await getDocumentById(rno);
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      // Row(
      //   children: [
      //     Text(data['name']),
      //     Container(
      //       width: 10,
      //     ),
      //     Text(data['roll number']),
      //     Container(
      //       width: 10,
      //     ),
      //     Text(data['class']),
      //     Container(
      //       width: 10,
      //     ),
      //   ],
      // );
      setState(() {
        name = data['name'];
      });
      setState(() {
        roll = data['roll number'];
      });
      setState(() {
        cla = data['class'];
      });
    } else {
      const snackBar = SnackBar(
        content: Text("Roll number doesn't exist"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        name = '';
      });
      setState(() {
        roll = '';
      });
      setState(() {
        cla = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View One"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 600,
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: rollval,
                decoration: InputDecoration(
                    hintText: 'Enter Roll number of student to display',
                    prefixIcon: Icon(Icons.abc),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ),
            Container(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => view(rollval.text)));
                  // Navigator.pop(context);
                  // Future<DocumentSnapshot<Map<String, dynamic>>> x =
                  //     getDocumentById(rollval.text);
                  _showDocumentData(rollval.text);
                },
                child: Text('Show')),
            // if(name.length!=0 && roll.length!=0 && cla.length!=0){
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Name: ${name}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Roll number: ${roll}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Class: ${cla}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // }
          ],
        ),
      ),
    );
  }
}
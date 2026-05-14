import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_expense_api/view/list_In_Out.dart';

import '../api_services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();

}
class _HomeScreen extends State<HomeScreen>{
  DateTime entry_time = DateTime.now() ;
  DateTime exit_time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              entry_time = DateTime.now();
            }, child: Text("Check IN")),
            ElevatedButton(onPressed: (){
              exit_time = DateTime.now();
            }, child: Text("check Out")),
            ElevatedButton(onPressed: (){
              ApiServices().addInOut(entry_time, exit_time);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListInOut()));
            }, child: Text("total")),
          ],
        ),
      )
    );
  }

}
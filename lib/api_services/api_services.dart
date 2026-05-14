import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  List data=[];

  Future<List<dynamic>> getInOut()async {
    final response = await http.get(Uri.parse("https://parking-api-fvn0.onrender.com/"));
    if(response.statusCode == 201 || response.statusCode ==200){
      data =json.decode(response.body);
      if(data != null){
        print("data fetched successfully");
      }


    }else{

      print("error in fetching");
    }
    return data;
  }
  Future<void> addInOut(DateTime entry_time ,DateTime exit_time )async {
    final response  =
    await http.post(Uri.parse("https://parking-api-fvn0.onrender.com/calculate-fare"),
        headers:{
        'Content-Type': 'application/json',
        },
      body: jsonEncode({
        "entry_time" : entry_time.toIso8601String(),
        "exit_time" : exit_time.toIso8601String()
      })
    );
    if(response.statusCode == 201 || response.statusCode==200){
      print("Data posted Successfully");
    }else{
      print("error in posting");
    }

  }
}
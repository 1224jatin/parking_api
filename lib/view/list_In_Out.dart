import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_expense_api/api_services/api_services.dart';

class ListInOut extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListInOut();

}
class _ListInOut extends State<ListInOut>{
  late final List posts ; 

  void initState(){
    loadData();
  }
  Future<void> loadData() async {
    await ApiServices().getInOut();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                  FutureBuilder(future: ApiServices().getInOut(), builder: (context,snapshot){
                    if (snapshot.connectionState== ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }
                    if(snapshot.hasError){
                      print("error");
                    }
                    if(snapshot.hasData){
                      final posts = snapshot.data;
                      print(" i have data ");
                      return Expanded(child:  ListView.builder(
                          itemCount: posts!.length,
                          itemBuilder: (context,index){
                            return Card(
                              child: Column(
                                children: [
                                  Text("check_in Time: - ${posts[index]["entry_time"]}]")
                                ],
                              ),
                            );

                          }));
                    }
                    else
                    {
                      return Text("noo");
                    }

                  })
                ],
              )
          ),
        );
  }

}
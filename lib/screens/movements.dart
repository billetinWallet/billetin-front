import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MovementPage extends StatefulWidget{
  const MovementPage({Key? key}): super(key: key);

  @override
  _MovementPageState createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage>{
  List _transactions  = [];
  int len = 0;
  final int userId = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Column(
        children: [
        Query(options: QueryOptions(
            document: gql(movementsByUserId()),
            variables: {'id_user':userId},
        ), 
        builder:(result, {VoidCallback? refetch, FetchMore? fetchMore}){
          if (result.isLoading) {
           return const Center(child: CircularProgressIndicator());
          }  

          if (result.hasException) {
           return Center(
             child: Text(result.exception.toString()),
           );
          }


          final data = result.data?["movementsByUserId"];
          // print(data);
          // print(data.runtimeType);
          _transactions = data;
          return Text("");
        
        }),
        Expanded(
          child: ListView.builder(
            itemCount:(_transactions.length),
            itemBuilder:(context, index){
              if(_transactions[index]['state'] == "A"){
                return MySquareApproved(
                  id_movement:_transactions[index]['id_movement'],
                  amount:_transactions[index]['amount']
                  
                );
              }
              return  MySquareDeclined(
                id_movement:_transactions[index]['id_movement'],
                amount:_transactions[index]['amount']
              );
            }))
      ]),
    );
}
}


class MySquareApproved extends StatelessWidget{
  final String id_movement;
  final int amount;

  MySquareApproved({required this.id_movement, required this.amount});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        color: Colors.green[200],
        child: Column(
          children: [
            Text(
              id_movement,
              style:TextStyle(fontSize: 20),
            ),
            Text(
              amount.toString(),
              style:TextStyle(fontSize: 20),
            )
          ],  
        ),
        ),
      );
  }
}

class MySquareDeclined extends StatelessWidget{
  final String id_movement;
  final int amount;

  MySquareDeclined({required this.id_movement, required this.amount});


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        color: Color.fromARGB(255, 240, 72, 63),
        child:  Column(
          children: [
            Text(
              id_movement,
              style:TextStyle(fontSize: 20),
            ),
            Text(
              amount.toString(),
              style:TextStyle(fontSize: 20),
            )
          ],  
        ),
      ),
      );
  }
}


String movementsByUserId(){
  return '''
     query GetMovementsByUserId(\$id_user: Int!) {
      movementsByUserId(id_user: \$id_user) {
      datetime
      id_movement
      state
      amount
    }
  }
''';
}


class Movement {
  final String datetime;
  final String id_movement;
  final String state;
  final int amount;

  Movement(this.datetime, this.id_movement, this.state, this.amount);

  Movement.fromJson(Map<String, dynamic> json)
      : datetime = json['datetime'],
        id_movement = json['id_movement'],
        state = json['state'],
        amount = json['amount'];

  Map<String, dynamic> toJson() => {
        'datetime': datetime,
        'id_movement': id_movement,
        'state':state,
        'amount':amount
      };
}
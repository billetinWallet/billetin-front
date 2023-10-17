import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MovementPage extends StatefulWidget{
  const MovementPage({Key? key}): super(key: key);

  @override
  _MovementPageState createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage>{
  //final List _transactions  = [];
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
          print(data);

          return Text("No widget to build");
        
        }),
        Expanded(
          child: ListView.builder(
            itemCount: 10,//_transactions.length,
            itemBuilder:(context, index){
              return MySquare();
            }))
      ]),
    );
}
}


class MySquare extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        color: Colors.green[200],
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
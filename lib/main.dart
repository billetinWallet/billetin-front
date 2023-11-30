import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'app.dart';

void main() async{
  await initHiveForFlutter();

  final GraphQLClient graphQLClient = GraphQLClient(
    link: HttpLink("http://172.171.242.73:5000/graphql?"),
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );

  final client = ValueNotifier(graphQLClient);
  runApp(
    GraphQLProvider(
      client: client,
      child: const billetinApp(),
    ),
  );
}

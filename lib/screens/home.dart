import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:billetin/content_extension.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.token}) : super(key: key);
  final String token;
  @override
  State<HomePage> createState() => _HomePageState(token);
}

class _HomePageState extends State<HomePage>{
  final _documentController = TextEditingController();
  final _amountController = TextEditingController();
  bool tran = false;
  double saldo = 0;
  String token="";
  int tx_target=0;

  _HomePageState(String token){this.token = token;}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, semanticLabel: "Menú",),
          onPressed: () => print("Menú activado"),
        ),
          title: const Text("billetinWallet"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: "Buscar",
            ),
            onPressed: () => print("Buscar"),
          ),
          IconButton(
            icon: const Icon(
              Icons.tune,
              semanticLabel: "Filtrar",
            ),
            onPressed: () => print("Filtra"),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 50),
            const Text("¡Bienvenido!", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Tu saldo actual:", style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 50),
            Query(
              key: UniqueKey(),
              options: QueryOptions(
                document: gql(currentBalance()),
                variables: {'id_user': JwtDecoder.decode(token)['id']},
              ),
              builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return const Center(child: Text("Error"));
                }
                saldo = result.data?["balanceByUserId"]["balance"].toDouble();
                return Center(child: Text(saldo.toString()+" COP", style: TextStyle(fontSize: 50)));
              },
            ),
            const SizedBox(height: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Enviar billetin"),
                  onPressed: (){
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(25),
                              topStart: Radius.circular(25),
                            )
                        ),
                        builder: (BuildContext context){
                          return Container(
                            height:400,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                )
                            ),
                            child:ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              children: <Widget>[
                                const SizedBox(height: 10),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: const Icon(Icons.arrow_back, semanticLabel: "Volver"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const SizedBox(height: 20),
                                const Center(child: Text("Enviar billetin")),
                                const SizedBox(height: 30),
                                TextFormField(
                                  controller: _documentController,
                                  decoration: const InputDecoration(
                                    labelText: "Número de documento",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _amountController,
                                  decoration: const InputDecoration(
                                    labelText: "Cantidad \$",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if(_documentController.text!="")
                                Query(
                                  options: QueryOptions(
                                    document: gql(findIdQuery()),
                                    variables: {'document_number': int.parse(_documentController.text)},
                                  ),
                                  builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                                    if (result.hasException) {
                                      return const Center(child: Text("Error"));
                                    }
                                    tx_target = result.data?["getUserId"]["id_user"];
                                    print(tx_target);
                                    return const SizedBox();
                                  },
                                ),
                                Mutation(
                                    options: MutationOptions(
                                      document: gql(createTransactionMutation()),
                                      onError: (exception){
                                        context.showSnackBar("Transacción fallida, revise e intente nuevamente");
                                      },
                                      onCompleted: (resultData){
                                        if (resultData!=null){
                                          context.showSnackBar("Transacción exitosa");
                                          print(resultData);
                                          setState(() {
                                            _documentController.clear();
                                            _amountController.clear();
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                    builder: (runMutation, result){
                                      if(result != null && result.isLoading){
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      return ElevatedButton(
                                        child: const Text("Transferir!"),
                                        onPressed: () {
                                          setState(() {
                                            tran = true;
                                          });
                                          createTransaction(runMutation);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            side: BorderSide.none,
                                          ),
                                          minimumSize: const Size(double.infinity, 48),
                                        ),
                                      );
                                    }
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.popAndPushNamed(context, "/historical");
                    },
                    child: const Text("Mis movimientos")
                ),
              ],
            )


          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  void createTransaction(RunMutation runMutation){
    final amount = double.parse(_amountController.text);
    runMutation({
      "internal_transaction":{
        "source_account": JwtDecoder.decode(token)["id"],
        "target_account": tx_target,
        "amount": amount },
    });
  }
  String findIdQuery() {
    return '''
    query GetUserId (\$document_number: Int!){
      getUserId(document_number: \$document_number) {
          id_user
      }
    }

    ''';
  }

  String currentBalance(){
    return '''
    query BalanceByUserId (\$id_user: Int!){
    balanceByUserId(id_user: \$id_user) {
        id_balance
        balance
        update_time
    }
}
    ''';
  }

  String createTransactionMutation(){
    return '''
    mutation CreateInternalTransaction(\$internal_transaction: InternalTransactionInput!) {
    createInternalTransaction(
        internal_transaction: \$internal_transaction
    ) {
        id_internal_transaction
        amount
        datetime
        state
        source_account {
            id_user
            document_number
        }
        target_account {
            id_user
            document_number
        }
    }
  } 
    ''';
  }
}

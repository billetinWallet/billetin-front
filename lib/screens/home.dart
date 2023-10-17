import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:billetin/content_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _documentController = TextEditingController();
  final _amountController = TextEditingController();

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
            const SizedBox(height: 300),
            ElevatedButton(
              child: const Text("Pasar billetin a otra persona"),
              onPressed: (){
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(25),
                          topStart: Radius.circular(25),
                        )
                    ),
                    builder: (BuildContext context){
                      return Container(
                        height:400,
                        decoration: BoxDecoration(
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
                            Center(child: Text("Enviar billetin")),
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
                            Mutation(
                                options: MutationOptions(
                                  document: gql(createUserMutation()),
                                  onError: (exception){
                                    context.showSnackBar("Transacción fallida, revise e intente nuevamente");
                                  },
                                  onCompleted: (resultData){
                                    if (resultData!=null){
                                      context.showSnackBar("Transacción exitosa");
                                      print(resultData);
                                      Navigator.popAndPushNamed(context, "/transactions");
                                    }
                                  },
                                ),
                                builder: (runMutation, result){
                                  if(result != null && result.isLoading){
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  return ElevatedButton(
                                    child: const Text("Transferir!"),
                                    onPressed: (){
                                      createUser(runMutation);
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

          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
  void createUser(RunMutation runMutation){
    final document = _documentController.text;
    final amount = double.parse(_amountController.text);
    runMutation({
      "internal_transaction":{
        "source_account": document,
        "target_account": document,
        "amount": amount },
    });
  }

  String createUserMutation(){
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

import 'package:billetin/content_extension.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}): super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late final _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _obscureText = true;
  static const List<String> sex = <String>['Masculino', 'Femenino'];
  String dropdownValue = sex.first;
  static const List<String> documentTypes = <String>['CC', 'TI'];
  String documentTypeValue = documentTypes.first;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1910, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = [selectedDate.year, selectedDate.month, selectedDate.day].join("-");
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, semanticLabel: "Volver a Log In"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 30.0),
            Column(
              children: <Widget>[
                Image.asset('assets/logo_clean.png'),
                const SizedBox(height: 20.0,),
                Text("¡Bienvenido a billetin!", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20.0,),
                Text("A continuación, digita tu información personal", style: Theme.of(context).textTheme.bodyMedium)
              ],
            ),
            const SizedBox(height: 30),
            const Text("Tipo de documento"),
            DropdownMenu<String>(
              initialSelection: '-',
              onSelected: (String? value){
                setState(() {
                  documentTypeValue = value!;
                });
              },
              dropdownMenuEntries: documentTypes.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Número de documento"),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  hintText: "# documento"
              ),
            ),
            const SizedBox(height:15),
            const Text("Contraseña"),
            TextFormField(
              obscureText: _obscureText,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Contraseña super secreta",
                suffixIcon: IconButton(
                  icon: Icon(_obscureText
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height:15),
            const Text("Nombre(s)"),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: "Pepito Alfredo"
              ),
            ),
            const SizedBox(height:15),
            const Text("Apellido(s)"),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                  hintText: "Perez Mercachifle"
              ),
            ),
            const SizedBox(height:15),
            const Text("Fecha de nacimiento"),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: [selectedDate.year, selectedDate.month, selectedDate.day].join("-"),
                suffixIcon: IconButton(
                    onPressed: (){
                      _selectDate(context);
                    },
                    icon: Icon(Icons.calendar_month)
                ),

              ),

            ),
            const SizedBox(height:15),
            const Text("Sexo biológico"),
            DropdownMenu<String>(
              initialSelection: '-',
              onSelected: (String? value){
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries: sex.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(height:40),
            Mutation(
                options: MutationOptions(
                  document: gql(createUserMutation()),
                  onError: (exception){
                    context.showSnackBar("Registro fallido, intente nuevamente");
                  },
                  onCompleted: (resultData){
                    if (resultData!=null){
                      context.showSnackBar("Registro exitoso");
                      Navigator.popAndPushNamed(context, "/login");
                    }
                  },
                ),
                builder: (runMutation, result){
                  if(result != null && result.isLoading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    child: const Text("¡Registrarme!"),
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
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void createUser(RunMutation runMutation){
    final document = _usernameController.text;
    final password = _passwordController.text;
    runMutation({
      "user":{
        "document_number": document,
        "password": password
      },
    });
  }

  String createUserMutation(){
    return '''
    mutation createUser(\$user: UserRequest!){
        newUser(User: \$user)
    }
    ''';
  }
}
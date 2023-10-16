import 'package:flutter/material.dart';

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
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1910, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 100.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/logo_clean.png'),
                  const SizedBox(height: 20.0,),
                  Text("¡Bienvenido!", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20.0,),
                  Text("A continuación, digita tu información personal", style: Theme.of(context).textTheme.bodyMedium)
                ],
              ),
              const SizedBox(height: 20),
              const Text("Número de documento"),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "# documento"
                ),
              ),
              const SizedBox(height:10),
              const Text("Contraseña"),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    hintText: "Contraseña super secreta"
                ),
              ),
              const SizedBox(height:10),
              const Text("Nombre(s)"),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    hintText: "Pepito Alfredo"
                ),
              ),
              const SizedBox(height:10),
              const Text("Apellido(s)"),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                    hintText: "Perez Mercachifle"
                ),
              ),
              const SizedBox(height:10),
              const Text("Fecha de nacimiento"),
              TextFormField(
                decoration: InputDecoration(
                  hintText: [selectedDate.year, selectedDate.month, selectedDate.day].join("-"),
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_month)
                  ),

                ),

              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text("¡Registrarme!"),
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide.none,
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
        ),
      ),
    );
  }
}
// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:billetin/content_extension.dart';
import 'package:billetin/screens/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 70.0,),
                Text("Digita tus credenciales para continuar", style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Número de documento",
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              obscureText: _obscureText,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Contraseña",
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => print("password recovery not implemented yet."),
                child: const Text(
                  "Olvidé mi contraseña"
                ),
              )
            ),
            const SizedBox(height: 40),
            Mutation(
                options: MutationOptions(
                  document: gql(loginUserMutation()),
                  onError: (exception){
                    context.showSnackBar("Inicio de sesión fallido, intente nuevamente");
                  },
                  onCompleted: (resultData){
                    if (resultData!=null){
                      context.showSnackBar("Inicio de sesión exitoso");
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage(token: resultData["createToken"]["access_token"]),
                      ));
                    }
                  },
                ),
                builder: (runMutation, result){
                  if(result != null && result.isLoading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    child: const Text("Iniciar sesión"),
                    onPressed: (){
                      loginUser(runMutation);
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
            const SizedBox(height: 10,),
            Center(
              child: RichText(
                text: TextSpan(
                    text: "¿Aún no estás registrado?",
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Regístrate",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Navigator.pushNamed(context, "/register");
                        },
                      ),
                    ]
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
  void loginUser(RunMutation runMutation){
    final document = _usernameController.text;
    final password = _passwordController.text;
    runMutation({
      "user":{
        "username": document,
        "password": password
      },
    });
  }

  String loginUserMutation(){
    return '''
    mutation CreateToken(\$user: Login!) {
      createToken(login: \$user) {
          access_token
          token_type
      }
    }
    ''';
  }



}

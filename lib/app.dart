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

import 'package:billetin/colors.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/transactions.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class billetinApp extends StatefulWidget {
  const billetinApp({Key? key}) : super(key: key);

  @override
  State<billetinApp> createState() => _billetinAppState();
}

class _billetinAppState extends State<billetinApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'billetin',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/register': (BuildContext context) => const RegisterPage(),
        '/transactions': (BuildContext context) => const TransactionPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: _billetinTheme,
      darkTheme: _billetinDarkTheme,
      themeMode: ThemeMode.light,
    );
  }
}

final ThemeData _billetinTheme = _buildBilletinTheme();
final ThemeData _billetinDarkTheme = _buildBilletinDarkTheme();

ThemeData _buildBilletinTheme(){
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: v3,
      onPrimary: b1,
      secondary: v2,
      error: er,
    ),

    textTheme: _buildBilletinTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: v3
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

ThemeData _buildBilletinDarkTheme(){
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: v3,
      onPrimary: Colors.black,
      secondary: v2,
      error: er,
    ),

    textTheme: _buildBilletinTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
        selectionColor: v3
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

TextTheme _buildBilletinTextTheme(TextTheme base) {
  return base.copyWith(
    headlineSmall: base.headlineSmall!.copyWith(
      fontWeight: FontWeight.w500,
    ),
    titleLarge: base.titleLarge!.copyWith(
      fontSize: 18.0,
    ),
    bodySmall: base.bodySmall!.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyLarge: base.bodyLarge!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: b1,
    bodyColor: b1,
  );
}

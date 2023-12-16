import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/constent2/intro.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/model/chat.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/signin.dart';
import 'package:frontend/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(),
    );
  }
}

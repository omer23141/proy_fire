import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proy_fire/pantallas/contactos.dart';
import 'package:proy_fire/pantallasLibros/libros.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Books(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

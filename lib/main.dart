import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../widgets/playernameform.dart';
import '../interface_user/room_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRUCO ROYALE',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const RoomSelectionScreen(),
    );
  }
}

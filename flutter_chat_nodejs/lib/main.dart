import 'package:flutter/material.dart';

import 'chatscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat flutter with nodejs',
      home: ChatScreen(),
    );
  }
}

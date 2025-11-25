import 'package:flutter/material.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erreur 404'),
      ),
      body: const Center(
        child: Text('Page non trouvée'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // AJOUTÉ

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        // Flèche de retour gérée automatiquement par GoRouter, plus besoin de `leading`
      ),
      body: const Center(
        child: Text('Page des paramètres'),
      ),
    );
  }
}

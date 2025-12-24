// lib/pages/connection_test_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConnectionTestPage extends StatelessWidget {
  const ConnectionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Connexion API'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final isConnected = await ApiService.testConnection();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(isConnected ? '✅ Connecté' : '❌ Non connecté'),
                      content: Text(
                        isConnected 
                          ? 'L\'API Flask répond correctement.'
                          : 'Impossible de se connecter à l\'API.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('❌ Erreur'),
                      content: Text('Erreur: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
                'Tester la connexion',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'URL API: ${ApiService.baseUrl}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
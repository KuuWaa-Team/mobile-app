import 'package:flutter/material.dart';

class CustomTemplateRequestScreen extends StatelessWidget {
  const CustomTemplateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demande de Template Personnalisé"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Conditions :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text("- Une caution de 100 \$ est requise."),
            const Text("- Le coût par invitation sera de 5 crédits."),
            const SizedBox(height: 20),
            const Text("Détails de votre design :"),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Nom de l'événement",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description ou idées du design",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Couleurs souhaitées",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Thème ou ambiance",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ici tu peux appeler ton API ou envoyer les infos à Firebase
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Demande envoyée avec succès.")),
                );
                Navigator.pop(context);
              },
              child: const Text("Soumettre ma demande"),
            ),
          ],
        ),
      ),
    );
  }
}

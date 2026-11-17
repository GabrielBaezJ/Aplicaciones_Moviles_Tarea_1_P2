import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control académico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.estudiantes),
              icon: const Icon(Icons.people),
              label: const Text('Estudiantes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.asignaturas),
              icon: const Icon(Icons.book),
              label: const Text('Asignaturas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.notas),
              icon: const Icon(Icons.assessment),
              label: const Text('Notas'),
            ),
          ],
        ),
      ),
    );
  }
}

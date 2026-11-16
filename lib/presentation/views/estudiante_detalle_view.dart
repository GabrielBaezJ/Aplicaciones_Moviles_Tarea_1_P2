import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/estudiantes.dart';
import '../viewmodels/estudiante_viewmodel.dart';

class EstudianteDetalleView extends StatelessWidget {
  const EstudianteDetalleView({super.key});

  @override
  Widget build(BuildContext context) {
    final estudiante = ModalRoute.of(context)!.settings.arguments as Estudiante;
    final vm = context.read<EstudianteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del estudiante')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${estudiante.nombre} ${estudiante.apellido}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(estudiante.email),
            const SizedBox(height: 24),
            if (estudiante.id == null)
              const Text('Promedio no disponible para este estudiante.')
            else
              FutureBuilder<double>(
                future: vm.obtenerPromedio(estudiante.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('No se pudo calcular el promedio');
                  }
                  return Text(
                    'Promedio: ${snapshot.data!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

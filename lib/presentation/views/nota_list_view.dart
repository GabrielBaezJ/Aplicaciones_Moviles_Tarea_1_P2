import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/estudiantes.dart';
import '../../domain/entities/nota.dart';
import '../../routes/app_routes.dart';
import '../viewmodels/asignatura_viewmodel.dart';
import '../viewmodels/estudiante_viewmodel.dart';
import '../viewmodels/nota_viewmodel.dart';

class NotaListView extends StatefulWidget {
  const NotaListView({super.key});

  @override
  State<NotaListView> createState() => _NotaListViewState();
}

class _NotaListViewState extends State<NotaListView> {
  Estudiante? _estudianteSeleccionado;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    _estudianteSeleccionado =
        ModalRoute.of(context)?.settings.arguments as Estudiante?;
    final estudiantes = context.read<EstudianteViewModel>();
    final asignaturas = context.read<AsignaturaViewModel>();
    final notas = context.read<NotaViewModel>();
    Future.microtask(() async {
      if (estudiantes.estudiantes.isEmpty) {
        await estudiantes.cargarEstudiantes();
      }
      if (asignaturas.asignaturas.isEmpty) {
        await asignaturas.cargarAsignaturas();
      }
      if (!mounted) return;
      final lista = estudiantes.estudiantes;
      if (_estudianteSeleccionado == null && lista.isNotEmpty) {
        setState(() => _estudianteSeleccionado = lista.first);
      }
      if (_estudianteSeleccionado != null) {
        await notas.cargarNotas(_estudianteSeleccionado!.id!);
      }
      if (mounted) setState(() {});
    });
  }

  Future<void> _seleccionarEstudiante(Estudiante? estudiante) async {
    setState(() => _estudianteSeleccionado = estudiante);
    if (estudiante != null) {
      await context.read<NotaViewModel>().cargarNotas(estudiante.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estudiantes = context.watch<EstudianteViewModel>().estudiantes;
    final asignaturas = context.watch<AsignaturaViewModel>().asignaturas;
    final vm = context.watch<NotaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.notaForm),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Estudiante>(
              initialValue: _estudianteSeleccionado,
              decoration: const InputDecoration(labelText: 'Estudiante'),
              items: estudiantes
                  .map(
                    (estudiante) => DropdownMenuItem(
                      value: estudiante,
                      child: Text(
                        '${estudiante.nombre} ${estudiante.apellido}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _seleccionarEstudiante,
            ),
            const SizedBox(height: 16),
            if (vm.cargando)
              const CircularProgressIndicator()
            else if (vm.error != null && vm.notas.isEmpty)
              Text(vm.error!)
            else if (vm.notas.isEmpty)
              const Text('No hay notas registradas')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: vm.notas.length,
                  itemBuilder: (context, index) {
                    final nota = vm.notas[index];
                    final coincidencias = asignaturas.where(
                      (item) => item.id == nota.asignaturaId,
                    );
                    final asignatura = coincidencias.isEmpty
                        ? null
                        : coincidencias.first;
                    return _NotaTile(
                      nota: nota,
                      asignatura:
                          asignatura?.nombre ??
                          'Asignatura ${nota.asignaturaId}',
                      situacion: vm.situacion(nota.valor),
                      onDelete: () => vm.eliminar(nota.id!),
                    );
                  },
                ),
              ),
            if (_estudianteSeleccionado != null)
              FutureBuilder<double>(
                future: vm.promedio(_estudianteSeleccionado!.id!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Promedio: ${snapshot.data!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NotaTile extends StatelessWidget {
  final Nota nota;
  final String asignatura;
  final String situacion;
  final Future<bool> Function() onDelete;

  const _NotaTile({
    required this.nota,
    required this.asignatura,
    required this.situacion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(asignatura),
      subtitle: Text(situacion),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nota.valor.toStringAsFixed(2)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await onDelete();
              if (!ok || !context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Nota eliminada')));
            },
          ),
        ],
      ),
    );
  }
}

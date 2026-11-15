import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../viewmodels/estudiante_viewmodel.dart';

class EstudianteListView extends StatefulWidget {
  const EstudianteListView({super.key});

  @override
  State<EstudianteListView> createState() => _EstudianteListViewState();
}

class _EstudianteListViewState extends State<EstudianteListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<EstudianteViewModel>().cargarEstudiantes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudianteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.estudianteForm),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (vm.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null && vm.estudiantes.isEmpty) {
            return Center(child: Text(vm.error!));
          }
          if (vm.estudiantes.isEmpty) {
            return const Center(child: Text('No hay estudiantes registrados'));
          }
          return ListView.builder(
            itemCount: vm.estudiantes.length,
            itemBuilder: (context, i) {
              final estudiante = vm.estudiantes[i];
              return ListTile(
                title: Text('${estudiante.nombre} ${estudiante.apellido}'),
                subtitle: Text(estudiante.email),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.estudianteDetalle,
                  arguments: estudiante,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.estudianteForm,
                        arguments: estudiante,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final ok = await vm.eliminar(estudiante.id!);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(vm.error ?? 'Error')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
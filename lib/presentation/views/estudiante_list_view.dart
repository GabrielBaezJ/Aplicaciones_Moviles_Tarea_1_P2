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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<EstudianteViewModel>().cargarEstudiantes();
    });
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
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null && vm.estudiantes.isEmpty
          ? Center(child: Text(vm.error!))
          : vm.estudiantes.isEmpty
          ? const Center(child: Text('No hay estudiantes registrados'))
          : ListView.builder(
              itemCount: vm.estudiantes.length,
              itemBuilder: (context, index) {
                final e = vm.estudiantes[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(e.nombre.isEmpty ? '?' : e.nombre[0]),
                  ),
                  title: Text('${e.nombre} ${e.apellido}'),
                  subtitle: Text(e.email),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.estudianteDetalle,
                    arguments: e,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: e.id == null
                            ? null
                            : () => Navigator.pushNamed(
                                context,
                                AppRoutes.estudianteForm,
                                arguments: e,
                              ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: e.id == null
                            ? null
                            : () async {
                                final ok = await vm.eliminar(e.id!);
                                if (!ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error ?? 'Error'),
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

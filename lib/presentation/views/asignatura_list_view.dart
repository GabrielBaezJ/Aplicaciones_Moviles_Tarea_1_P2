import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../viewmodels/asignatura_viewmodel.dart';

class AsignaturaListView extends StatefulWidget {
  const AsignaturaListView({super.key});

  @override
  State<AsignaturaListView> createState() => _AsignaturaListViewState();
}

class _AsignaturaListViewState extends State<AsignaturaListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AsignaturaViewModel>().cargarAsignaturas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsignaturaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Asignaturas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.asignaturaForm),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (vm.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null && vm.asignaturas.isEmpty) {
            return Center(child: Text(vm.error!));
          }
          if (vm.asignaturas.isEmpty) {
            return const Center(child: Text('No hay asignaturas registradas'));
          }
          return ListView.builder(
            itemCount: vm.asignaturas.length,
            itemBuilder: (context, i) {
              final asignatura = vm.asignaturas[i];
              return ListTile(
                title: Text(asignatura.nombre),
                subtitle: Text(asignatura.codigo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.asignaturaForm,
                        arguments: asignatura,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final ok = await vm.eliminar(asignatura.id!);
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
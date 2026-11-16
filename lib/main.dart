import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/estudiante_api.dart';
import 'data/repositories/estudiante_repository_impl.dart';
import 'domain/usecases/actualizar_estudiante.dart';
import 'domain/usecases/crear_estudiantes.dart';
import 'domain/usecases/eliminar_estudiante.dart';
import 'domain/usecases/obtener_estudiantes.dart';
import 'presentation/viewmodels/estudiante_viewmodel.dart';
import 'routes/app_routes.dart';

import 'data/datasources/asignatura_api.dart';
import 'data/repositories/asignatura_repository_impl.dart';
import 'domain/usecases/actualizar_asignatura.dart';
import 'domain/usecases/crear_asignatura.dart';
import 'domain/usecases/eliminar_asignatura.dart';
import 'domain/usecases/obtener_asignaturas.dart';
import 'presentation/viewmodels/asignatura_viewmodel.dart';

void main() {
  final estudianteRepo = EstudianteRepositoryImpl(api: EstudianteApi());
  final asignaturaRepo = AsignaturaRepositoryImpl(api: AsignaturaApi());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EstudianteViewModel(
            obtenerEstudiantes: ObtenerEstudiantes(repository: estudianteRepo),
            crearEstudiantes: CrearEstudiantes(repository: estudianteRepo),
            actualizarEstudiante: ActualizarEstudiante(
              repository: estudianteRepo,
            ),
            eliminarEstudiante: EliminarEstudiante(
              repository: estudianteRepo,
              tieneNotas: (id) async => false,
            ),
            obtenerPromedio: (id) async => 0.0,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AsignaturaViewModel(
            obtenerAsignaturas: ObtenerAsignaturas(repository: asignaturaRepo),
            crearAsignatura: CrearAsignatura(repository: asignaturaRepo),
            actualizarAsignatura: ActualizarAsignatura(
              repository: asignaturaRepo,
            ),
            eliminarAsignatura: EliminarAsignatura(repository: asignaturaRepo),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control académico',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.inicio,
      routes: AppRoutes.rutas,
    );
  }
}

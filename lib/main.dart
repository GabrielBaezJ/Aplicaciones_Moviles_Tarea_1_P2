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
import 'data/datasources/nota_remote_datasource.dart';
import 'data/repositories/nota_repository_impl.dart';
import 'domain/usecases/calcular_promedio.dart';
import 'domain/usecases/determinar_situacion_academica.dart';
import 'domain/usecases/eliminar_nota.dart';
import 'domain/usecases/obtener_notas_por_estudiante.dart';
import 'domain/usecases/registrar_nota.dart';
import 'presentation/viewmodels/nota_viewmodel.dart';

void main() {
  final estudianteRepo = EstudianteRepositoryImpl(api: EstudianteApi());
  final asignaturaRepo = AsignaturaRepositoryImpl(api: AsignaturaApi());
  final notaRepo = NotaRepositoryImpl(datasource: NotaRemoteDatasource());
  final calcularPromedio = CalcularPromedio(repository: notaRepo);

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
              tieneNotas: notaRepo.tieneNotas,
            ),
            obtenerPromedio: calcularPromedio.ejecutar,
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
        ChangeNotifierProvider(
          create: (_) => NotaViewModel(
            registrarNota: RegistrarNota(
              notaRepository: notaRepo,
              estudianteRepository: estudianteRepo,
              asignaturaRepository: asignaturaRepo,
            ),
            obtenerNotasPorEstudiante: ObtenerNotasPorEstudiante(
              repository: notaRepo,
            ),
            calcularPromedio: calcularPromedio,
            determinarSituacion: DeterminarSituacionAcademica(),
            eliminarNota: EliminarNota(repository: notaRepo),
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

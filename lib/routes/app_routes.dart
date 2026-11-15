import 'package:flutter/material.dart';

import '../presentation/views/asignatura_form_view.dart';
import '../presentation/views/asignatura_list_view.dart';
import '../presentation/views/estudiante_detalle_view.dart';
import '../presentation/views/estudiante_form_view.dart';
import '../presentation/views/estudiante_list_view.dart';
import '../presentation/views/inicio_view.dart';

class AppRoutes {
  static const String inicio = '/inicio';
  static const String estudiantes = '/estudiantes';
  static const String estudianteForm = '/estudiante-form';
  static const String estudianteDetalle = '/estudiante-detalle';
  static const String asignaturas = '/asignaturas';
  static const String asignaturaForm = '/asignatura-form';

  //TODO: rutas de notas (Integrante 3)

  static Map<String, WidgetBuilder> get rutas => {
    inicio: (_) => const InicioView(),
    estudiantes: (_) => const EstudianteListView(),
    estudianteForm: (_) => const EstudianteFormView(),
    estudianteDetalle: (_) => const EstudianteDetalleView(),
    asignaturas: (_) => const AsignaturaListView(),
    asignaturaForm: (_) => const AsignaturaFormView(),
  };
}
import 'package:flutter/material.dart';

import '../presentation/views/estudiante_detalle_view.dart';
import '../presentation/views/estudiante_form_view.dart';
import '../presentation/views/estudiante_list_view.dart';

class AppRoutes {
  static const String estudiantes = '/estudiantes';
  static const String estudianteForm = '/estudiante-form';
  static const String estudianteDetalle = '/estudiante-detalle';
  //TODO: rutas de asignaturas y notas (Integrantes 2 y 3)

  static Map<String, WidgetBuilder> get rutas => {
    estudiantes: (_) => const EstudianteListView(),
    estudianteForm: (_) => const EstudianteFormView(),
    estudianteDetalle: (_) => const EstudianteDetalleView(),
  };
}

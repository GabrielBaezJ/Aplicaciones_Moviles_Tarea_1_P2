import 'package:flutter/material.dart';

import '../../domain/entities/nota.dart';
import '../../domain/usecases/calcular_promedio.dart';
import '../../domain/usecases/determinar_situacion_academica.dart';
import '../../domain/usecases/eliminar_nota.dart';
import '../../domain/usecases/obtener_notas_por_estudiante.dart';
import '../../domain/usecases/registrar_nota.dart';

class NotaViewModel extends ChangeNotifier {
  final RegistrarNota registrarNota;
  final ObtenerNotasPorEstudiante obtenerNotasPorEstudiante;
  final CalcularPromedio calcularPromedio;
  final DeterminarSituacionAcademica determinarSituacion;
  final EliminarNota eliminarNota;

  NotaViewModel({
    required this.registrarNota,
    required this.obtenerNotasPorEstudiante,
    required this.calcularPromedio,
    required this.determinarSituacion,
    required this.eliminarNota,
  });

  List<Nota> notas = [];
  bool cargando = false;
  String? error;

  Future<void> cargarNotas(int estudianteId) async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      notas = await obtenerNotasPorEstudiante.ejecutar(estudianteId);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
    cargando = false;
    notifyListeners();
  }

  Future<bool> registrar(Nota nota) async {
    try {
      final nueva = await registrarNota.ejecutar(nota);
      notas = [...notas, nueva];
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    try {
      await eliminarNota.ejecutar(id);
      notas.removeWhere((nota) => nota.id == id);
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<double> promedio(int estudianteId) {
    return calcularPromedio.ejecutar(estudianteId);
  }

  String situacion(double valor) {
    return determinarSituacion.ejecutar(valor);
  }
}

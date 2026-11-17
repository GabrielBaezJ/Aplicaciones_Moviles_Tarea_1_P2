import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/estudiante_model.dart';

class EstudianteApi {
  final String url =
      'https://6af92e0c6d8b86fb22d6d8be.mockapi.io/api/v1/estudiantes';
  final http.Client? client;

  EstudianteApi({this.client});

  Future<List<EstudianteModel>> obtenerEstudiantes() async {
    final uri = Uri.parse('$url?limit=20');
    final respuesta = await (client?.get(uri) ?? http.get(uri));
    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      if (datos is! List) {
        throw const FormatException(
          'La respuesta de estudiantes debe ser una lista.',
        );
      }
      return datos.asMap().entries.map((entry) {
        final item = entry.value;
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Cada estudiante debe ser un objeto JSON.',
          );
        }
        final estudiante = EstudianteModel.fromJson(item);
        if (estudiante.id != null) return estudiante;
        return EstudianteModel(
          id: entry.key + 1,
          nombre: estudiante.nombre,
          apellido: estudiante.apellido,
          email: estudiante.email,
        );
      }).toList();
    }
    throw Exception('Error al cargar estudiantes');
  }

  Future<EstudianteModel> crearEstudiante(EstudianteModel estudiante) async {
    final uri = Uri.parse(url);
    final respuesta =
        await (client?.post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(estudiante.toJson()),
            ) ??
            http.post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(estudiante.toJson()),
            ));
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return EstudianteModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al crear estudiante');
  }

  Future<EstudianteModel> actualizarEstudiante(
    EstudianteModel estudiante,
  ) async {
    final uri = Uri.parse('$url/${estudiante.id}');
    final respuesta =
        await (client?.put(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(estudiante.toJson()),
            ) ??
            http.put(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(estudiante.toJson()),
            ));
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return EstudianteModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al actualizar estudiante');
  }

  //metodo eliminar estudiante
  Future<void> eliminarEstudiante(int id) async {
    final uri = Uri.parse('$url/$id');
    final respuesta = await (client?.delete(uri) ?? http.delete(uri));
    if (respuesta.statusCode != 200) {
      throw Exception('Error al eliminar estudiante');
    }
  }
}

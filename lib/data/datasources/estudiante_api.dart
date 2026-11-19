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
      return datos.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Cada estudiante debe ser un objeto JSON.',
          );
        }
        return EstudianteModel.fromJson(item);
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
    final id = estudiante.idRemoto ?? estudiante.id?.toString();
    if (id == null || id.isEmpty) {
      throw Exception('La API no devolvió el identificador del estudiante. Revisa el campo ID en MockAPI.');
    }
    final uri = Uri.parse('$url/${Uri.encodeComponent(id)}');
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
      final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
      return EstudianteModel.fromJson({...estudiante.toJson(), ...datos, 'id': id});
    }
    if (respuesta.statusCode == 204) return estudiante;
    throw Exception('No se pudo actualizar el estudiante (HTTP ${respuesta.statusCode}).');
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

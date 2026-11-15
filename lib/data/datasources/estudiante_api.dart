import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/estudiante_model.dart';

class EstudianteApi {
  final String url =
      'https://6af92e0c6d8b86fb22d6d8be.mockapi.io/api/v1/estudiantes';

  //modelo obtener estudiante
  Future<List<EstudianteModel>> obtenerEstudiantes() async {
    final respuesta = await http.get(Uri.parse('$url?limit=20'));
    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final lista = datos['users'] as List;

      return lista.map((item) => EstudianteModel.fromJson(item)).toList();
    }
    throw Exception('Error al cargar estudiantes');
  }

  //metodo crear estudiante
  Future<EstudianteModel> crearEstudiante(EstudianteModel estudiante) async {
    final respuesta = await http.post(
      Uri.parse('$url/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(estudiante.toJson()),
    );
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return EstudianteModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al crear estudiante');
  }

  //metodo actualizar estudiante
  Future<EstudianteModel> actualizarEstudiante(
    EstudianteModel estudiante,
  ) async {
    final respuesta = await http.put(
      Uri.parse('$url/${estudiante.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(estudiante.toJson()),
    );
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return EstudianteModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al actualizar estudiante');
  }

  //metodo eliminar estudiante
  Future<void> eliminarEstudiante(int id) async {
    final respuesta = await http.delete(Uri.parse('$url/$id'));
    if (respuesta.statusCode != 200) {
      throw Exception('Error al eliminar estudiante');
    }
  }
}

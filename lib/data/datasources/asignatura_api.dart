import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/asignatura_model.dart';

class AsignaturaApi {
  final String url =
      'https://6af92e0c6d8b86fb22d6d8be.mockapi.io/api/v1/asignaturas';

  Future<List<AsignaturaModel>> obtenerAsignaturas() async {
    final respuesta = await http.get(Uri.parse('$url?limit=20'));
    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final lista = datos['products'] as List;
      return lista.map((item) => AsignaturaModel.fromJson(item)).toList();
    }
    throw Exception('Error al cargar asignaturas');
  }

  Future<AsignaturaModel> crearAsignatura(AsignaturaModel asignatura) async {
    final respuesta = await http.post(
      Uri.parse('$url/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(asignatura.toJson()),
    );
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return AsignaturaModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al crear asignatura');
  }

  Future<AsignaturaModel> actualizarAsignatura(
    AsignaturaModel asignatura,
  ) async {
    final respuesta = await http.put(
      Uri.parse('$url/${asignatura.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(asignatura.toJson()),
    );
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return AsignaturaModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al actualizar asignatura');
  }

  Future<void> eliminarAsignatura(int id) async {
    final respuesta = await http.delete(Uri.parse('$url/$id'));
    if (respuesta.statusCode != 200) {
      throw Exception('Error al eliminar asignatura');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/nota_model.dart';

class NotaRemoteDatasource {
  static const String url =
      'https://6af92e0c6d8b86fb22d6d8be.mockapi.io/api/v1/notas';

  Future<NotaModel> registrarNota(NotaModel nota) async {
    final respuesta = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nota.toJson()),
    );
    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return NotaModel.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Error al registrar nota');
  }

  Future<List<NotaModel>> obtenerNotasPorEstudiante(int estudianteId) async {
    final respuesta = await http.get(
      Uri.parse('$url?estudianteId=$estudianteId'),
    );
    if (respuesta.statusCode == 200) {
      final lista = jsonDecode(respuesta.body) as List;
      return lista
          .map((item) => NotaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error al cargar notas');
  }

  Future<void> eliminarNota(int id) async {
    final respuesta = await http.delete(Uri.parse('$url/$id'));
    if (respuesta.statusCode != 200) {
      throw Exception('Error al eliminar nota');
    }
  }
}

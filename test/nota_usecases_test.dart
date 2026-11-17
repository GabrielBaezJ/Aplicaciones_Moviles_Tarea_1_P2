import 'package:flutter_test/flutter_test.dart';

import 'package:pry_tarea_1/domain/entities/asignatura.dart';
import 'package:pry_tarea_1/domain/entities/estudiantes.dart';
import 'package:pry_tarea_1/domain/entities/nota.dart';
import 'package:pry_tarea_1/domain/repositories/asignatura_repository.dart';
import 'package:pry_tarea_1/domain/repositories/estudiante_repository.dart';
import 'package:pry_tarea_1/domain/repositories/nota_repository.dart';
import 'package:pry_tarea_1/domain/usecases/calcular_promedio.dart';
import 'package:pry_tarea_1/domain/usecases/determinar_situacion_academica.dart';
import 'package:pry_tarea_1/domain/usecases/registrar_nota.dart';

void main() {
  final estudiante = Estudiante(
    id: 1,
    nombre: 'Ana',
    apellido: 'Pérez',
    email: 'ana@example.com',
  );
  final asignatura = Asignatura(id: 1, nombre: 'Matemática', codigo: 'MAT');

  test('Registra una nota válida asociada a entidades existentes', () async {
    final notas = FakeNotaRepository();
    final registrar = RegistrarNota(
      notaRepository: notas,
      estudianteRepository: FakeEstudianteRepository([estudiante]),
      asignaturaRepository: FakeAsignaturaRepository([asignatura]),
    );

    final resultado = await registrar.ejecutar(
      Nota(id: null, estudianteId: 1, asignaturaId: 1, valor: 18),
    );

    expect(resultado.valor, 18);
    expect(notas.registradas, hasLength(1));
  });

  test('Rechaza notas fuera del rango permitido', () async {
    final registrar = RegistrarNota(
      notaRepository: FakeNotaRepository(),
      estudianteRepository: FakeEstudianteRepository([estudiante]),
      asignaturaRepository: FakeAsignaturaRepository([asignatura]),
    );

    expect(
      () => registrar.ejecutar(
        Nota(id: null, estudianteId: 1, asignaturaId: 1, valor: 20.1),
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('Calcula promedio y situación académica', () async {
    final promedio = await CalcularPromedio(
      repository: FakeNotaRepository([
        Nota(id: 1, estudianteId: 1, asignaturaId: 1, valor: 18),
        Nota(id: 2, estudianteId: 1, asignaturaId: 1, valor: 10),
      ]),
    ).ejecutar(1);

    final situacion = DeterminarSituacionAcademica();

    expect(promedio, 14);
    expect(situacion.ejecutar(14), 'Aprobado');
    expect(situacion.ejecutar(13.99), 'Recuperación');
    expect(situacion.ejecutar(8.99), 'Reprobado');
  });
}

class FakeEstudianteRepository implements EstudianteRepository {
  final List<Estudiante> estudiantes;

  FakeEstudianteRepository(this.estudiantes);

  @override
  Future<Estudiante> actualizarEstudiante(Estudiante estudiante) {
    throw UnimplementedError();
  }

  @override
  Future<Estudiante> crearEstudiante(Estudiante estudiante) {
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarEstudiante(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Estudiante>> obtenerEstudiante() async => estudiantes;
}

class FakeAsignaturaRepository implements AsignaturaRepository {
  final List<Asignatura> asignaturas;

  FakeAsignaturaRepository(this.asignaturas);

  @override
  Future<Asignatura> actualizarAsignatura(Asignatura asignatura) {
    throw UnimplementedError();
  }

  @override
  Future<Asignatura> crearAsignatura(Asignatura asignatura) {
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarAsignatura(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Asignatura>> obtenerAsignaturas() async => asignaturas;
}

class FakeNotaRepository implements NotaRepository {
  final List<Nota> registradas;

  FakeNotaRepository([List<Nota>? notas]) : registradas = [...?notas];

  @override
  Future<Nota> registrarNota(Nota nota) async {
    final nueva = Nota(
      id: registradas.length + 1,
      estudianteId: nota.estudianteId,
      asignaturaId: nota.asignaturaId,
      valor: nota.valor,
    );
    registradas.add(nueva);
    return nueva;
  }

  @override
  Future<List<Nota>> obtenerNotasPorEstudiante(int estudianteId) async {
    return registradas
        .where((nota) => nota.estudianteId == estudianteId)
        .toList();
  }

  @override
  Future<void> eliminarNota(int id) async {
    registradas.removeWhere((nota) => nota.id == id);
  }

  @override
  Future<bool> tieneNotas(int estudianteId) async {
    return registradas.any((nota) => nota.estudianteId == estudianteId);
  }
}

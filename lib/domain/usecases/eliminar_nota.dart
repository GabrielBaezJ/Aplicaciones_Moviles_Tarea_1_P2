import '../repositories/nota_repository.dart';

class EliminarNota {
  final NotaRepository repository;

  EliminarNota({required this.repository});

  Future<void> ejecutar(int id) {
    return repository.eliminarNota(id);
  }
}

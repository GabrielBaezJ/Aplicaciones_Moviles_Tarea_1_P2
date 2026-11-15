import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/asignatura.dart';
import '../viewmodels/asignatura_viewmodel.dart';

class AsignaturaFormView extends StatefulWidget {
  const AsignaturaFormView({super.key});

  @override
  State<AsignaturaFormView> createState() => _AsignaturaFormViewState();
}

class _AsignaturaFormViewState extends State<AsignaturaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _codigo = TextEditingController();
  Asignatura? _asignatura;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    _asignatura = ModalRoute.of(context)?.settings.arguments as Asignatura?;
    if (_asignatura != null) {
      _nombre.text = _asignatura!.nombre;
      _codigo.text = _asignatura!.codigo;
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AsignaturaViewModel>();
    final asignatura = Asignatura(
      id: _asignatura?.id,
      nombre: _nombre.text.trim(),
      codigo: _codigo.text.trim(),
    );
    final ok = _asignatura == null
        ? await vm.agregar(asignatura)
        : await vm.editar(asignatura);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _asignatura == null ? 'Nueva asignatura' : 'Editar asignatura',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _codigo,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
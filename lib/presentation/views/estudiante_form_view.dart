import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/estudiantes.dart';
import '../viewmodels/estudiante_viewmodel.dart';

class EstudianteFormView extends StatefulWidget {
  const EstudianteFormView({super.key});

  @override
  State<EstudianteFormView> createState() => _EstudianteFormViewState();
}

class _EstudianteFormViewState extends State<EstudianteFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _email = TextEditingController();
  Estudiante? _estudiante;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    _estudiante = ModalRoute.of(context)?.settings.arguments as Estudiante?;
    if (_estudiante != null) {
      _nombre.text = _estudiante!.nombre;
      _apellido.text = _estudiante!.apellido;
      _email.text = _estudiante!.email;
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<EstudianteViewModel>();
    final estudiante = Estudiante(
      id: _estudiante?.id,
      nombre: _nombre.text.trim(),
      apellido: _apellido.text.trim(),
      email: _email.text.trim(),
    );
    final ok = _estudiante == null
        ? await vm.agregar(estudiante)
        : await vm.editar(estudiante);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _estudiante == null ? 'Nuevo estudiante' : 'Editar estudiante',
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
                controller: _apellido,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Email inválido' : null,
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

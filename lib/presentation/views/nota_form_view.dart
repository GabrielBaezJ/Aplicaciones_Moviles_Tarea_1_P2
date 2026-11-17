import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/asignatura.dart';
import '../../domain/entities/estudiantes.dart';
import '../../domain/entities/nota.dart';
import '../viewmodels/asignatura_viewmodel.dart';
import '../viewmodels/estudiante_viewmodel.dart';
import '../viewmodels/nota_viewmodel.dart';

class NotaFormView extends StatefulWidget {
  const NotaFormView({super.key});

  @override
  State<NotaFormView> createState() => _NotaFormViewState();
}

class _NotaFormViewState extends State<NotaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _valor = TextEditingController();
  Estudiante? _estudianteSeleccionado;
  Asignatura? _asignaturaSeleccionada;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final estudiante =
        ModalRoute.of(context)?.settings.arguments as Estudiante?;
    _estudianteSeleccionado = estudiante;
    final estudiantes = context.read<EstudianteViewModel>();
    final asignaturas = context.read<AsignaturaViewModel>();
    Future.microtask(() async {
      if (estudiantes.estudiantes.isEmpty) {
        await estudiantes.cargarEstudiantes();
      }
      if (asignaturas.asignaturas.isEmpty) {
        await asignaturas.cargarAsignaturas();
      }
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _valor.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<NotaViewModel>().registrar(
      Nota(
        id: null,
        estudianteId: _estudianteSeleccionado!.id!,
        asignaturaId: _asignaturaSeleccionada!.id!,
        valor: double.parse(_valor.text.trim()),
      ),
    );
    if (!ok || !mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final estudiantes = context.watch<EstudianteViewModel>().estudiantes;
    final asignaturas = context.watch<AsignaturaViewModel>().asignaturas;
    final error = context.watch<NotaViewModel>().error;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar nota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Estudiante>(
                initialValue: _estudianteSeleccionado,
                decoration: const InputDecoration(labelText: 'Estudiante'),
                items: estudiantes
                    .map(
                      (estudiante) => DropdownMenuItem(
                        value: estudiante,
                        child: Text(
                          '${estudiante.nombre} ${estudiante.apellido}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _estudianteSeleccionado = value),
                validator: (value) => value == null || value.id == null
                    ? 'El estudiante no tiene un identificador válido'
                    : null,
              ),
              DropdownButtonFormField<Asignatura>(
                initialValue: _asignaturaSeleccionada,
                decoration: const InputDecoration(labelText: 'Asignatura'),
                items: asignaturas
                    .map(
                      (asignatura) => DropdownMenuItem(
                        value: asignatura,
                        child: Text(
                          '${asignatura.codigo} - ${asignatura.nombre}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _asignaturaSeleccionada = value),
                validator: (value) =>
                    value == null ? 'Seleccione una asignatura' : null,
              ),
              TextFormField(
                controller: _valor,
                decoration: const InputDecoration(labelText: 'Nota (0-20)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final nota = double.tryParse(value?.trim() ?? '');
                  if (nota == null || nota < 0 || nota > 20) {
                    return 'Ingrese una nota entre 0 y 20';
                  }
                  return null;
                },
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error, style: TextStyle(color: Colors.red.shade700)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:pry_tarea_1/main.dart';

void main() {
  testWidgets('Muestra el menú principal de control académico', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Control académico'), findsOneWidget);
    expect(find.text('Estudiantes'), findsOneWidget);
    expect(find.text('Asignaturas'), findsOneWidget);
    expect(find.text('Notas'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:finanzas_personales/main.dart';

void main() {
  testWidgets('La app inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const FinanzasPersonalesApp(),
    );

    expect(
      find.text('Mis Finanzas'),
      findsOneWidget,
    );
  });
}
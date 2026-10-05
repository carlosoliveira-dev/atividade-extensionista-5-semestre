import 'package:flutter_test/flutter_test.dart';
import 'package:atividade_extensionista_5_semestre/main.dart';

void main() {
  testWidgets('ImpactCarApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ImpactCarApp());
    expect(find.text('Impact Car'), findsWidgets);
  });
}

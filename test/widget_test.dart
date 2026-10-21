import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jip_frontend/main.dart';
import 'package:jip_frontend/providers/company_provider.dart';

void main() {
  testWidgets('App displays the company management screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CompanyProvider(),
        child: const JipApp(),
      ),
    );

    // Check the main screen and its action buttons.
    expect(find.text('Company Management'), findsOneWidget);
    expect(find.text('Add Company'), findsOneWidget);
    expect(find.text('Add Service'), findsOneWidget);
  });
}

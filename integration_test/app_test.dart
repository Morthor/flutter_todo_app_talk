import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app_embbedv2/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testing item:', () {
    testWidgets('Create new item', (WidgetTester tester) async {
      final String itemTitle = 'new item created by test';

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text("New todo"), findsOneWidget);

      await tester.enterText(find.byType(TextField), itemTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('item-0')), findsOneWidget);
    });

    testWidgets('Set item as completed', (WidgetTester tester) async {
      final String itemTitle = 'new item created by test';

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), itemTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('item-0')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('completed-icon-0')), findsOneWidget);
    });

    testWidgets('Edit item', (WidgetTester tester) async {
      final String itemTitle = 'new item created by test';
      final String editedItemTitle = 'item edited by test';

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), itemTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.longPress(find.byKey(Key('item-0')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), editedItemTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, editedItemTitle), findsOneWidget);
    });

    testWidgets('Delete item', (WidgetTester tester) async {
      final String itemTitle = 'new item created by test';

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text("New todo"), findsOneWidget);

      await tester.enterText(find.byType(TextField), itemTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(Key('item-0')), Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('item-0')), findsNothing);
    });
  });


}
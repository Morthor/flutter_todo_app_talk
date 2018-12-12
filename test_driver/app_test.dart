import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('Starting app:', () {
    final appTitle = find.byValueKey('main-app-title');
    test('App starts and shows the main view', () async {
      expect(await driver.getText(appTitle), "FlutterTodo",);
    });
  });

  group('Testing item:', () {
    test('Go to new item view', () async {
      final newItemTitle = find.byValueKey('new-item-title');

      await driver.tap(find.byType('FloatingActionButton'));
      await driver.waitFor(newItemTitle);

      expect(await driver.getText(newItemTitle), "New todo");
    });

    test('Create new item', () async {
      final String itemTitle = 'new item created by test';

      await driver.tap(find.byType("TextField"));
      await driver.enterText(itemTitle);
      await driver.tap(find.byType("RaisedButton"));

      expect(await driver.getText(find.byValueKey('item-0')), itemTitle);
    });

    test('Edit item', () async {
      final String itemTitle = 'item edited by test';

      await driver.tap(find.byType("IconButton"));
      await driver.tap(find.byType("TextField"));
      await driver.enterText(itemTitle);
      await driver.tap(find.byType("RaisedButton"));

      expect(await driver.getText(find.byValueKey('item-0')), itemTitle);
    });

    test('Delete item', () async {
      final item = find.byValueKey('item-0');
      await driver.waitFor(item);
      await driver.scroll(item, 200.0, 0.0, Duration(milliseconds: 100));
      await driver.waitForAbsent(item);
    });
  });
}
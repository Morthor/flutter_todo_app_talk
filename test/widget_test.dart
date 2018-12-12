import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/main.dart';
import 'package:todo_app1/todo.dart';

void main() {
  testWidgets('Test Home Widget by checking if the title is present on app start', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialAppTester(Home())
    );

    expect(find.text('FlutterTodo'), findsOneWidget);
  });

  testWidgets('Test new empty NewTodo Widget by checking if the title is  present and the item is null', (WidgetTester tester) async {
    final newTodo = new NewTodo();

    await tester.pumpWidget(
      MaterialAppTester(newTodo)
    );

    expect(find.text('New todo'), findsOneWidget);
    expect(newTodo.item, null);
    expect(find.byType(RaisedButton), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Test NewTodo Widget with an item by checking if the title is present, the item was loaded and set on the textfield', (WidgetTester tester) async {
    final item = new Todo(title: 'test todo');
    final newTodo = new NewTodo(item: item,);

    await tester.pumpWidget(
      MaterialAppTester(newTodo)
    );

    expect(find.text('New todo'), findsOneWidget);
    expect(newTodo.item, item);
    expect(find.text(item.title), findsOneWidget);
  });
}

// This Widget is here to enable testing widgets on their own, without the main App, by running inside a base MaterialApp.
class MaterialAppTester extends StatelessWidget {
  final Widget testWidget;

  MaterialAppTester(this.testWidget);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialAppTester',
      home: this.testWidget,
    );
  }
}
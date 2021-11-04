import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_embbedv2/new_todo.dart';
import 'package:todo_app_embbedv2/main.dart';
import 'package:todo_app_embbedv2/todo.dart';

void main() {
  testWidgets('Test Home Widget by checking if the title is present on app start', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialAppTester(Home())
    );

    expect(find.text('FlutterTodo'), findsOneWidget);
  });

  testWidgets('Test new empty NewTodo Widget by checking if the title is present and the item is new', (WidgetTester tester) async {
    final newTodoView = new NewTodoView(item: Todo(title: ''),);

    await tester.pumpWidget(
      MaterialAppTester(newTodoView)
    );

    expect(find.text('New todo'), findsOneWidget);
    expect(newTodoView.item.title, '');
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Test NewTodo Widget with an item by checking if the title is present, the item was loaded and set on the textfield', (WidgetTester tester) async {
    final item = new Todo(title: 'test todo');
    final newTodoView = new NewTodoView(item: item,);

    await tester.pumpWidget(
      MaterialAppTester(newTodoView)
    );

    expect(find.text('Edit todo'), findsOneWidget);
    expect(newTodoView.item, item);
    expect(find.text('test todo'), findsOneWidget);
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
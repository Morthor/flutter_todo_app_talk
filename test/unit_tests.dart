import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_embbedv2/main.dart';
import 'package:todo_app_embbedv2/todo.dart';

void main(){
  group('Home', () {
    test('item list should be empty', () {
      final homeState = HomeState();
      expect(homeState.items.length, 0);
    });

    test('item list should have 1 item and it should be an instance of Todo class', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');

      homeState.addItem(item);
      expect(homeState.items.length, 1);

      item = homeState.items.first;
      expect(item.runtimeType, Todo);
    });

    test('item in list should be modified', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');

      homeState.addItem(item);
      item.updateTitle('edited test todo');

      expect(item.title, 'edited test todo');
    });

    test('item in list should be deleted and list should be empty again', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');

      homeState.addItem(item);
      homeState.deleteItem(item);

      expect(homeState.items.length, 0);
    });
  });
}
import 'package:test/test.dart';
import 'package:todo_app1/main.dart';
import 'package:todo_app1/todo.dart';

void main(){
  group('Home', () {
    test('item list should be empty', () {
      final homeState = HomeState();
      expect(homeState.list.length, 0);
    });

    test('item list should have 1 item and it should be an instance of Todo class', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');

      homeState.addItem(item);
      expect(homeState.list.length, 1);

      item = homeState.list.first;
      expect(item.runtimeType, Todo);
    });

    test('item in list should be modified', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');
      String title = 'edited test todo';

      homeState.addItem(item);
      homeState.editItem(item, title);

      expect(item.title, title);
    });

    test('item in list should be deleted and list should be empty again', () {
      final homeState = HomeState();
      Todo item = new Todo(title: 'new test todo');

      homeState.addItem(item);
      homeState.removeItem(item);

      expect(homeState.list.length, 0);
    });
  });
}
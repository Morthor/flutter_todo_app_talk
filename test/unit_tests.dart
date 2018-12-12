import 'package:test/test.dart';
import 'package:todo_app1/main.dart';
import 'package:todo_app1/todo.dart';

void main(){
  group('Home', () {
    final homeState = HomeState();
    Todo item;

    test('item list should be empty', () {
      expect(HomeState().items.length, 0);
    });

    test('item list should have 1 item and it should be an instance of Todo class', () {
      homeState.addItem('new test todo');
      item = homeState.items.first;

      expect(item.runtimeType, Todo);
      expect(homeState.items.length, 1);
    });

    test('item in list should be modified', () {
      homeState.editItem(item, 'edited test todo');

      expect(item.title, 'edited test todo');
    });

    test('item in list should be deleted and list should be empty again', () {
      homeState.deleteItem(item);

      expect(homeState.items.length, 0);
    });
  });
}
import 'package:test/test.dart';
import 'package:todo_app1/main.dart';
import 'package:todo_app1/todo.dart';

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

    test('list items displayed should be different when the filter changes', (){
      final homeState = HomeState();
      Todo item1 = new Todo(title: 'new test todo');
      item1.completed = true;
      Todo item2 = new Todo(title: 'new test todo');

      homeState.addItem(item1);
      homeState.addItem(item2);
      homeState.filteredItems = homeState.items;

      expect(homeState.filteredItems.length, 2);

      homeState.setFilterAndFilteredItems(ItemFilter.completed);
      expect(homeState.filteredItems.length, 1);
      expect(homeState.filteredItems[0].completed, true);

      homeState.setFilterAndFilteredItems(ItemFilter.incomplete);
      expect(homeState.filteredItems.length, 1);
      expect(homeState.filteredItems[0].completed, false);
    });
  });
}
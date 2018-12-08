import 'package:uuid/uuid.dart';

class Todo{
  String id = new Uuid().v1();
  String title;
  bool completed;

  Todo({
    this.title,
    this.completed = false,
  });

  Todo.fromMap(Map<String, dynamic> map)
    : id = map['id'].toString(),
      title = map['title'],
      completed = map['completed'];

  Map toMap(){
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
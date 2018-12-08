import 'dart:math';

Random randomSeed = new Random(1);

class Todo{
  int id = randomSeed.nextInt(9999999);
  String title;
  bool completed;

  Todo({
    this.title,
    this.completed = false,
  });

  Todo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
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
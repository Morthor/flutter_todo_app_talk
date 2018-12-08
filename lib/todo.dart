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

  Todo.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        completed = json['completed'];

  Map toMap(){
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
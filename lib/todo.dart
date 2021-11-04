class Todo{
  String title;
  bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });

  Todo.fromMap(Map<String, dynamic> map) :
    title = map['title'],
    completed = map['completed'];

  updateTitle(title){
    this.title = title;
  }

  Map toMap(){
    return {
      'title': title,
      'completed': completed,
    };
  }
}
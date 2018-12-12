import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTodo',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List<Todo> items = new List<Todo>();
  GlobalKey<AnimatedListState> animatedListKey
    = new GlobalKey<AnimatedListState>();
  AnimationController noItemsController;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    noItemsController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
  }

  @override
  void dispose(){
    noItemsController.dispose();
    super.dispose();
  }

  _loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringList = sharedPreferences.getStringList('data');
    setState(() {
      if(stringList != null) {
        stringList.forEach((string) {
          items.add(Todo.fromMap(json.decode(string)));
        });
      }
    });
  }

  _saveData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringList = new List<String>();
    items.forEach((Todo item){
      stringList.add(json.encode(item.toMap()));
    });
    sharedPreferences.setStringList('data', stringList);
  }

  @override
  Widget build(BuildContext context) {
    items.length == 0 ? noItemsController.forward() : noItemsController.reset();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlutterTodo',
          key: Key('main-app-title'),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Hero(
        tag: 'save-button',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () =>goToNewItemView(),
        ),
      ),
      body: items.length > 0
        ? buildListView()
        : emptyList()
    );
  }
  
  Widget emptyList(){
    return FadeTransition(
      opacity: noItemsController,
      child: Center(
      child:  Text('No items')
      ),
    );
  }

  Widget buildListView() {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: items.length,
      itemBuilder: (BuildContext context,int index, animation){
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: buildItem(items[index], index)
          ),
        );
      },
    );
  }

  Widget buildItem(Todo item, index){
    return Dismissible(
      key: Key('${item.id}'),
      background: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border(
                bottom: BorderSide(
                  color: Colors.red.withAlpha(50),
                  width: 1.0
                )
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(Icons.delete, color: Colors.white,),
            ),
          ),
          Container(
            height: 1.0,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black,
                blurRadius: 8.0,
                spreadRadius: 1.0
              ),]
            ),
          ),
        ],
      ),
      onDismissed: (direction) => _removeItem(item),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        onTap: () => _changeItemCompleteness(item),
        title: Text(
          item.title,
          key: Key('item-$index'),
          style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null
          ),
        ),
        trailing: IconButton(
          key: Key('edit-item'),
          icon: Icon(Icons.edit),
          onPressed: () => goToEditItemView(item),
        ),
      ),
    );
  }

  void _changeItemCompleteness(item){
    setState(() {
      items.firstWhere(
              (listItem) => item.id == listItem.id
      ).completed = !item.completed;
    });
  }

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodo();
    })).then((title){
      if(title != null) {
        addItem(title);
        _saveData();
      }
    });
  }

  void addItem(title){
    items.insert(0, Todo(title: title));
    if(animatedListKey.currentState != null){
      animatedListKey.currentState.insertItem(0);
    }
  }

  void goToEditItemView(item){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodo(item: item);
    })).then((title){
      if(title != null) {
        editItem(item, title);
        _saveData();
      }
    });
  }

  void editItem(item, title){
    items.firstWhere((listItem) => listItem.id == item.id).title = title;
  }

  void _removeItem(item) {
    animatedListKey.currentState.removeItem(
      items.indexOf(item), (context, animation){
        return SizedBox();
      }
    );
    deleteItem(item);
    _saveData();
  }

  void deleteItem(item){
    items.remove(items.firstWhere((listItem) => listItem.id == item.id));
  }
}
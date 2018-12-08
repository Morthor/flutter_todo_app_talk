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
      title: 'Todo App',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List<Todo> _items = new List<Todo>();
  GlobalKey<AnimatedListState> animatedListKey
    = new GlobalKey<AnimatedListState>();
  AnimationController noItemsAC;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    noItemsAC = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
  }

  _loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringList = sharedPreferences.getStringList('data');
    setState(() {
      if(stringList != null) {
        stringList.forEach((string) {
          _items.add(Todo.fromMap(json.decode(string)));
        });
      }
    });
  }

  _saveData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringList = new List<String>();
    _items.forEach((Todo item){
      stringList.add(json.encode(item.toMap()));
    });
    sharedPreferences.setStringList('data', stringList);
  }

  @override
  Widget build(BuildContext context) {
    _items.length == 0 ? noItemsAC.forward() : noItemsAC.reset();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
      ),
      floatingActionButton: Hero(
        tag: 'save-button',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () =>_newItemView(),
        ),
      ),
      body: _items.length > 0
        ? buildListView()
        : emptyList()
    );
  }
  
  Widget emptyList(){
    return FadeTransition(
      opacity: noItemsAC,
      child: Center(
      child:  Text('No items')
      ),
    );
  }

  Widget buildListView() {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: _items.length,
      itemBuilder: (BuildContext context,int index, animation){
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: buildItem(_items[index])
          ),
        );
      },
    );
  }

  Widget buildItem(Todo item){
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
        onTap: () => _editItem(item),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null
          ),
        ),
        trailing: completedButton(item),
      ),
    );
  }

  Widget completedButton(item){
    return IconButton(
      icon: Icon(
        item.completed ? Icons.check_box : Icons.check_box_outline_blank
      ),
      onPressed: () {
        setState(() {
          _items.firstWhere(
            (listItem) => item.id == listItem.id
          ).completed = !item.completed;
        });
      },
    );
  }

  void _newItemView(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodo();
    })).then((title){
      if(title != null) {
        setState(() {
          _items.insert(0, Todo(title: title));
        });
        if(animatedListKey.currentState != null){
          animatedListKey.currentState.insertItem(0);
        }
      }
      _saveData();
    });
  }

  void _editItem(item){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodo(item: item);
    })).then((title){
      if(title != null) {
        setState(() {
          _items.firstWhere((listItem) => listItem.id == item.id).title = title;
        });
      }
      _saveData();
    });
  }

  void _removeItem(item) {
    animatedListKey.currentState.removeItem(
      _items.indexOf(item), (context, animation){
        return SizedBox();
      }
    );
    setState(() {
      _items.remove(_items.firstWhere((listItem) => listItem.id == item.id));
    });
    _saveData();
  }
}
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
        primarySwatch: Colors.orange,
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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    noItemsController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose(){
    // Dispose of the animation to avoid leaks
    noItemsController.dispose();
    super.dispose();
  }

  _loadData() async {
    setState(() {
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringList = sharedPreferences.getStringList('data');
    if(stringList != null && stringList.length > 0) {
      setState(() {
        items.addAll(stringList.map((String item) {
          return Todo.fromMap(json.decode(item));
        }));
      });
      noItemsController.reset();
    } else {
      noItemsController.forward();
    }
    setState(() {
      loading = false;
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
      body: renderBody()
    );
  }

  Widget renderBody(){
    if(loading){
      return loadingScreen();
    }else if(items.length > 0){
      return buildListView();
    }else{
      return emptyList();
    }
  }
  
  Widget emptyList(){
    return FadeTransition(
      opacity: noItemsController,
      child: Center(
      child:  Text('No items')
      ),
    );
  }

  Widget loadingScreen(){
    return Center(
      child: CircularProgressIndicator(),
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
      onDismissed: (direction) => _removeItemFromList(item),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        onTap: () => changeItemCompleteness(item),
        onLongPress: () => goToEditItemView(item),
        title: Text(
          item.title,
          key: Key('item-$index'),
          style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null
          ),
        ),
        trailing: Icon(item.completed ? Icons.check_box : Icons.check_box_outline_blank),
      ),
    );
  }

  void changeItemCompleteness(Todo item){
    setState(() {
      item.completed = !item.completed;
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

  void editItem(Todo item ,String title){
    item.title = title;
  }

  void _removeItemFromList(item) {
    animatedListKey.currentState.removeItem(
      items.indexOf(item), (context, animation){
        return SizedBox();
      }
    );
    deleteItem(item);
    if(items.length == 0) {
      // force redraw of main view if the list is now empty
      setState(() {
        noItemsController.forward();
      });
    } else{
      noItemsController.reset();
    }
    _saveData();
  }

  void deleteItem(item){
    items.remove(item);
  }
}
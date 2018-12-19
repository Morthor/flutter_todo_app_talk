import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Main());

enum ItemFilter {
  all,
  incomplete,
  completed
}

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

// To have a custom set animation, the class needs to have a TickerProvider
class HomeState extends State<Home> with TickerProviderStateMixin{
  List<Todo> items = new List<Todo>();
  List<Todo> filteredItems = new List<Todo>();

  GlobalKey<AnimatedListState> animatedListKey
    = new GlobalKey<AnimatedListState>();
  AnimationController animationController;
  SharedPreferences sharedPreferences;
  bool loading = true;
  ItemFilter filter = ItemFilter.all;

  @override
  void initState() {
    super.initState();
    _loadData();
    // The AnimationController needs to be initiated inside the initState so
    // that vsync which controls the animation can be set
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    animationController.forward();
  }

  @override
  void dispose(){
    // Dispose of the animation to avoid leaks
    animationController.dispose();
    super.dispose();
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
      body: renderBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              color: filter == ItemFilter.all
                ? Theme.of(context).primaryColor
                : Colors.black,
              onPressed: () => changeFilter(ItemFilter.all)),
            IconButton(
              icon: Icon(Icons.check_box),
                color: filter == ItemFilter.completed
                  ? Theme.of(context).primaryColor
                  : Colors.black,
              onPressed: () => changeFilter(ItemFilter.completed)),
            IconButton(
              icon: Icon(Icons.check_box_outline_blank),
                color: filter == ItemFilter.incomplete
                  ? Theme.of(context).primaryColor
                  : Colors.black,
              onPressed: () => changeFilter(ItemFilter.incomplete)),
            SizedBox(width: 30.0,)
          ],
        ),
      ),
    );
  }

  Widget renderBody(){
    if(loading){
      return loadingScreen();
    }else if(filteredItems.length > 0){
      return buildListView();
    }else{
      return emptyList();
    }
  }
  
  Widget emptyList(){
    animationController.reset();
    animationController.forward();
    return SizeTransition(
      sizeFactor: animationController,
      child: FadeTransition(
        opacity: animationController,
        child: Center(
        child:  Text('No items')
        ),
      ),
    );
  }

  Widget loadingScreen(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildListView() {
    return SizeTransition(
      sizeFactor: animationController,
      child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (BuildContext context,int index){
          return buildItem(filteredItems[index], index);
        },
      ),
    );
  }

  Widget buildItem(Todo item, index){
    return Dismissible(
      key: Key('${item.hashCode}'),
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
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index){
    return ListTile(
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
      trailing: Icon(item.completed
        ? Icons.check_box
        : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  void changeItemCompleteness(Todo item){
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView(){
    // Here we are pushing the new view into the Navigator stack. By using a
    // MaterialPageRoute we get standard behaviour of a Material app, which will
    // show a back button automatically for each platform on the left top corner
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView();
    })).then((title){
      if(title != null) {
        addItem(Todo(title: title));
        _saveData();
      }
    });
  }

  void addItem(Todo item){
    // Insert an item into the top of our list, on index zero
    items.insert(0, item);
    if(animatedListKey.currentState != null){
      animatedListKey.currentState.insertItem(0);
    }
  }

  void goToEditItemView(item){
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView(item: item);
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
    deleteItem(item);
    if(items.length == 0) {
      // force redraw of main view if the list is now empty
      setState(() {
        animationController.forward();
      });
    } else{
      animationController.reset();
    }
    _saveData();
  }

  void deleteItem(item){
    // We don't need to search for our item on the list because Dart objects
    // are all uniquely identified by a hashcode. This means we just need to
    // pass our object on the remove method of the list
    items.remove(item);
  }

  void changeFilter(newFilter){
    animationController.reverse().then((a){
      animationController.forward();
      setState(() {
        filter = newFilter;
        filteredItems = filteredList();
      });
    });

  }

  List<Todo> filteredList(){
    switch (filter) {
      case ItemFilter.all:
        return items;
        break;

      case ItemFilter.completed:
        return items.where((item) => item.completed).toList();
        break;

      case ItemFilter.incomplete:
        return items.where((item) => !item.completed).toList();
        break;

      default:
        return items;
    }
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
        filteredItems = items;
      });
      animationController.reset();
    } else {
      animationController.forward();
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
}
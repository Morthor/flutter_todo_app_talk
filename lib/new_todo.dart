import 'package:flutter/material.dart';
import 'package:todo_app1/todo.dart';

class NewTodo extends StatefulWidget {
  final Todo item;

  NewTodo({ this.item });

  @override
  _NewTodoState createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
      text: widget.item != null ? widget.item.title : null
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('New todo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: titleController,
              autofocus: true,
              onSubmitted: (value) => submit(),
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 14.0,),
            Hero(
              tag: 'save-button',
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color
                  ),
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
                onPressed: () => submit(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submit(){
    Navigator.of(context).pop(titleController.text);
  }
}

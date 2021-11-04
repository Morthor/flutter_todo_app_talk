import 'package:flutter/material.dart';
import 'todo.dart';

class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({ required this.item });

  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
      text: widget.item.title
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.title != '' ? 'Edit todo' : 'New todo',
          key: Key('new-item-title'),
        ),
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
              onEditingComplete: submit,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 14.0,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).backgroundColor,
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }

  void submit(){
    if(titleController.text != '')
      Navigator.of(context).pop(titleController.text);
  }
}

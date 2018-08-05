import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final name = "Tasker";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: name,
        home: Scaffold(
            appBar: AppBar(
              title: Text(name),
              actions: <Widget>[
                new IconButton(
                    icon: const Icon(Icons.list), onPressed: _pushAddTasks)
              ],
            ),
            //body: new Center(child: TaskView())),
            body: Container(margin: EdgeInsets.all(30.0), child: TaskView())));
  }

  void _pushAddTasks() {}
}

class TaskView extends StatefulWidget {
  @override
  State createState() => new TaskViewState();
}

class TaskViewState extends State<TaskView> {
  static List<Priority> priorities = <Priority>[
    const Priority("Low", 1),
    const Priority("Medium", 2),
    const Priority("High", 3)
  ];

  final _formKey = GlobalKey<FormState>();
  var _selectedPriority = priorities[1];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child:  new LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _createValidatedFormTextField("Task Name"),
                  _createValidatedFormTextField("Description"),
                  Column(
                    children: <Widget>[
                      Text("Priority"),
                      new DropdownButton<Priority>(
                        hint: new Text("Select a priority"),
                        value: _selectedPriority,
                        onChanged: (Priority newValue) {
                          setState(() {
                            _selectedPriority = newValue;
                          });
                        },
                        items: priorities.map((Priority priority) {
                          print(priorities[2]);
                          return new DropdownMenuItem<Priority>(
                            value: priority,
                            child: new Text(
                              priority.name,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Align(
                    child: RaisedButton(
                      child: Text("Add"),
                      color: Colors.lightBlue,
                      onPressed: _onAdd,
                      textColor: Colors.white,
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                ],
              ),
            ),
          );
        })
    );
  }

  Widget _createValidatedFormTextField(String name) {
    return TextFormField(
      // The validator receives the text the user has typed in
      decoration: new InputDecoration(hintText: name),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  void _onAdd() {}
}

class Priority {
  const Priority(this.name, this.level);

  final String name;
  final int level;
}

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final name = "Tasker";

  static final List<Task> tasks = new List<Task>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: name, home: MainTaskView());
  }
}

class MainTaskView extends StatefulWidget {
  @override
  State createState() => new MainTaskViewState();
}

class MainTaskViewState extends State<MainTaskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.name),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _pushAddTasks)
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          _buildListView(),
        ],
      ),
    );
  }

  void _pushAddTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskView()),
    );
  }

  Widget _buildListView(){
    if(MyApp.tasks.length <= 0){
      return Center(child: Text("No tasks to display",style: TextStyle(fontSize: 32.0),));
    }else{
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: MyApp.tasks.length,
        itemBuilder: (BuildContext context, int i) {



          final int index = (MyApp.tasks.length - 1) - i;
          print("index is " + i.toString());
          print(MyApp.tasks[index].name);

          if(MyApp.tasks[index] != null){
            return new Card(
              child: Column(
                children: <Widget>[
                  _buildRow(MyApp.tasks[index]),
                ],
              ),
            );
          }



        },
      );
    }

  }

  Widget _buildRow(Task task) {
    IconTheme _iconDataToDisplay;

    switch (task.priority.level) {
      case 1:
        _iconDataToDisplay = IconTheme(child: Icon(Icons.low_priority), data: IconThemeData(color: Colors.green));
        break;
      case 2:
        _iconDataToDisplay = IconTheme(child: Icon(Icons.assignment_late), data: IconThemeData(color: Colors.orange));
        break;
      case 3:
        _iconDataToDisplay = IconTheme(child: Icon(Icons.priority_high), data: IconThemeData(color: Colors.red));
        break;
      default:
        _iconDataToDisplay = IconTheme(child: Icon(Icons.broken_image), data: IconThemeData(color: Colors.purple));
    }

    return new ListTile(
      trailing: _iconDataToDisplay,
      title: Text(task.name),
      subtitle: Text(task.description),
    );
  }
}

class AddTaskView extends StatefulWidget {
  @override
  State createState() => new AddTaskViewState();
}

class AddTaskViewState extends State<AddTaskView> {
  static List<Priority> priorities = <Priority>[
    const Priority("Low", 1),
    const Priority("Medium", 2),
    const Priority("High", 3)
  ];

  TextEditingController _taskNameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _selectedPriority = priorities[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyApp.name),
        ),
        //body: new Center(child: TaskView())),
        body: Container(
            margin: EdgeInsets.all(30.0),
            child: Form(
                key: _formKey,
                child: new LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _createValidatedFormTextField(
                              "Task Name", _taskNameController),
                          _createValidatedFormTextField(
                              "Description", _descriptionController),
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
                }))));
  }

  Widget _createValidatedFormTextField(
      String name, TextEditingController controller) {
    return TextFormField(
      // The validator receives the text the user has typed in
      decoration: new InputDecoration(hintText: name),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      controller: controller,
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onAdd() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      MyApp.tasks.add(new Task(_taskNameController.text,
          _descriptionController.text, _selectedPriority));
    }
  }
}

class Priority {
  const Priority(this.name, this.level);

  final String name;
  final int level;
}

class Task {
  Task(this.name, this.description, this.priority);

  String name;
  String description;

  Priority priority;
}

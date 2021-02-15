import 'package:flutter/material.dart';
import 'package:todo_app/utils/validators.dart';

class TaskSheet extends StatefulWidget {
  final String title;
  final String description;
  TaskSheet({@required this.title, this.description});
  _TaskSheet createState() => _TaskSheet();
}

class _TaskSheet extends State<TaskSheet> {
  TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.description != null) {
      taskController.text = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              widget.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: taskFormKey,
              child: TextFormField(
                controller: taskController,
                validator: (val) {
                  return nullTextValidate(val.trim());
                },
                maxLines: 6,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                  color: Colors.blueAccent,
                ))),
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (String val){
                  if (taskFormKey.currentState.validate()) {
                    Navigator.pop(context, taskController.text.trim());
                  }
                },
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (taskFormKey.currentState.validate()) {
                Navigator.pop(context, taskController.text.trim());
              }
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.blueAccent,
          ),
          Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          )
        ],
      ),
    );
  }
}

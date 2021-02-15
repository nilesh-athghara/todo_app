import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentations/task_sheet.dart';
import 'package:todo_app/redux/middlewares/ui_functions/task_functions.dart';
import 'package:todo_app/utils/toast.dart';

class TaskTile extends StatefulWidget {
  final Store store;
  final Task task;
  final Function(bool) setAppBarLoader;
  TaskTile(
      {@required this.task,
      @required this.store,
      @required this.setAppBarLoader})
      : super(key: UniqueKey());
  _TaskTile createState() => _TaskTile();
}

class _TaskTile extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          child: Row(
            children: [
              Checkbox(
                  value: widget.task.completedAt == null ? false : true,
                  onChanged: (bool val) {
                    if (val) {
                      completeTask(
                          store: widget.store,
                          userId: widget.store.state.user.userId.toString(),
                          taskId: widget.task.id);
                    } else {
                      unCompleteTask(
                          store: widget.store,
                          userId: widget.store.state.user.userId.toString(),
                          taskId: widget.task.id);
                    }
                  }),
              Expanded(
                  child: Text(
                widget.task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: widget.task.completedAt == null
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                  color: widget.task.completedAt == null
                      ? Colors.black
                      : Colors.grey,
                ),
              )),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    widget.setAppBarLoader(true);
                    bool deleted = await deleteTask(
                        store: widget.store,
                        userId: widget.store.state.user.userId.toString(),
                        taskId: widget.task.id);
                    widget.setAppBarLoader(false);
                    if (!deleted) {
                      showToast("Something went wrong!");
                    }
                  })
            ],
          )),
      onTap: () async {
        String text = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            builder: (BuildContext context) {
              return TaskSheet(
                title: "Edit task",
                description: widget.task.description,
              );
            });
        if (text != null && text != "") {
          widget.setAppBarLoader(true);
          bool posted = await updateTask(
              store: widget.store,
              userId: widget.store.state.user.userId.toString(),
              description: text,
              taskId: widget.task.id);
          widget.setAppBarLoader(false);
          if (!posted) {
            showToast("Something went wrong!");
          }
        }
      },
    );
  }
}

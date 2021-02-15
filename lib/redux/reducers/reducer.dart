import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/redux/actions/middlewares_actions.dart';

List<Task> storeTasks(List<Task> posts, ActionStoreTasks action) {
  return action.tasks;
}

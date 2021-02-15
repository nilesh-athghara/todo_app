import 'package:redux/redux.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/redux/actions/middlewares_actions.dart';
import 'package:todo_app/redux/reducers/reducer.dart';

Reducer<List<Task>> taskReducer = combineReducers<List<Task>>([
  TypedReducer<List<Task>, ActionStoreTasks>(storeTasks),
]);

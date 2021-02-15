import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/redux/actions/middlewares_actions.dart';
import 'package:todo_app/utils/keys.dart';

Future<bool> fetchTasks(
    {@required Store store, @required String userId}) async {
  bool fetched = false;
  final String url = "$apiUrl/users/$userId/tasks";
  final response = await http.get(url);
  if (response.statusCode == 200) {
    fetched = true;
    List<Task> tasks = taskListFromJson(response.body);
    tasks = arrange(tasks);
    store.dispatch(ActionStoreTasks(tasks));
  }
  return fetched;
}

Future<bool> createTask(
    {@required Store store,
    @required String userId,
    @required String description}) async {
  bool posted = false;
  final String url = "$apiUrl/users/$userId/tasks";
  final body = {
    "task": {"description": "$description"}
  };
  final response = await http.post(
    url,
    body: json.encode(body),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 201) {
    posted = true;
    Task task = taskFromJson(response.body);
    List<Task> existingTasks = store.state.tasks;
    existingTasks.insert(0, task);
    store.dispatch(ActionStoreTasks(existingTasks));
  }
  return posted;
}

Future<bool> updateTask(
    {@required Store store,
    @required String userId,
    @required String description,
    @required int taskId}) async {
  bool posted = false;
  final String url = "$apiUrl/users/$userId/tasks/${taskId.toString()}";
  final body = {
    "task": {"description": "$description"}
  };
  final response = await http.put(
    url,
    body: json.encode(body),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    posted = true;
    List<Task> existingTasks = store.state.tasks;
    Task toAppend = existingTasks.firstWhere((element) => element.id == taskId);
    toAppend.description = description;
    store.dispatch(ActionStoreTasks(existingTasks));
  }
  return posted;
}

Future<bool> deleteTask(
    {@required Store store,
    @required String userId,
    @required int taskId}) async {
  bool deleted = false;
  final String url = "$apiUrl/users/$userId/tasks/${taskId.toString()}";
  final response = await http.delete(
    url,
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 204) {
    deleted = true;
    List<Task> existingTasks = store.state.tasks;
    int index = existingTasks.indexWhere((element) => element.id == taskId);
    existingTasks.removeAt(index);
    store.dispatch(ActionStoreTasks(existingTasks));
  }
  return deleted;
}

void completeTask(
    {@required Store store, @required String userId, @required int taskId}) {
  List<Task> existingTasks = store.state.tasks;
  Task toAppend = existingTasks.firstWhere((element) => element.id == taskId);
  toAppend.completedAt = DateTime.now();
  existingTasks = arrange(existingTasks);
  store.dispatch(ActionStoreTasks(existingTasks));
  final String url =
      "$apiUrl/users/$userId/tasks/${taskId.toString()}/completed";
  http.put(
    url,
    headers: {"Content-Type": "application/json"},
  );
}

void unCompleteTask(
    {@required Store store, @required String userId, @required int taskId}) {
  List<Task> existingTasks = store.state.tasks;
  Task toAppend = existingTasks.firstWhere((element) => element.id == taskId);
  toAppend.completedAt = null;
  existingTasks = arrange(existingTasks);
  store.dispatch(ActionStoreTasks(existingTasks));
  final String url =
      "$apiUrl/users/$userId/tasks/${taskId.toString()}/uncompleted";
  http.put(
    url,
    headers: {"Content-Type": "application/json"},
  );
}

//sorting and segregation
//not the best practice, can be done at server side very efficiently

List<Task> arrange(List<Task> tasks) {
  List<Task> completed = [];
  List<Task> uncompleted = [];
  tasks.forEach((element) {
    if (element.completedAt == null)
      uncompleted.add(element);
    else
      completed.add(element);
  });
  completed.sort((a, b) => a.completedAt.compareTo(b.completedAt));
  uncompleted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return uncompleted + completed;
}

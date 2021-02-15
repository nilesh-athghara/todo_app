import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/keys.dart';

class AppState {
  final UserModel user;
  final List<Task> tasks;
  const AppState({this.user, this.tasks});
  factory AppState.initialState() {
    return AppState(user: UserModel(userId: fixedUserId), tasks: []);
  }

  //helper methods for local storage(if needed)
  static AppState fromJson(dynamic json) {
    if (json == null) return null;
    return AppState(
      user: UserModel.fromJson(json["user"]),
      tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
    );
  }

  dynamic toJson() => {
        "user": user.toJson(),
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

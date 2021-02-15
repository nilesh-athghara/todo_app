import 'package:todo_app/models/app_state.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/redux/reducers/reducer_closures.dart';
import 'package:todo_app/utils/keys.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
      user: UserModel(userId: fixedUserId),
      tasks: taskReducer(state.tasks, action));
}

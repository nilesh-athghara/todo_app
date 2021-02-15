import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/containers/app.dart';
import 'package:todo_app/models/app_state.dart';
import 'package:todo_app/redux/reducers/app_reducer.dart';

void main() {
  final Store<AppState> store = Store<AppState>(appStateReducer,
      initialState: AppState.initialState(),
      middleware: []);
  runApp(MyApp(store: store,));
}

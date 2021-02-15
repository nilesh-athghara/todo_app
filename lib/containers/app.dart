import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/containers/tasks_screen.dart';
import 'package:todo_app/models/app_state.dart';

class MyApp extends StatefulWidget {
  final Store store;
  MyApp({
    @required this.store,
  });
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: widget.store,
        child: MaterialApp(
          title: 'Todo_App',
          debugShowCheckedModeBanner: false,
          home: TasksScreen(
            store: widget.store,
          ),
        ));
  }
}

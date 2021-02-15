import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/models/app_state.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/presentations/task_sheet.dart';
import 'package:todo_app/presentations/null_container.dart';
import 'package:todo_app/presentations/task_tile.dart';
import 'package:todo_app/redux/middlewares/ui_functions/task_functions.dart';
import 'package:todo_app/utils/toast.dart';

class TasksScreen extends StatefulWidget {
  final Store store;
  TasksScreen({@required this.store});
  _TasksScreen createState() => _TasksScreen();
}

class _TasksScreen extends State<TasksScreen> {
  ScreenState screenState = ScreenState.loading;

  //loader stats
  bool appBarLoader = false;

  void setAppBarLoader(bool val) {
    setState(() {
      appBarLoader = val;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    bool fetched = await fetchTasks(
        store: widget.store, userId: widget.store.state.user.userId.toString());
    if (!fetched)
      setState(() {
        screenState = ScreenState.error;
      });
    else
      setState(() {
        screenState = ScreenState.tasks;
      });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) {
      return ViewModel.create(store);
    }, builder: (BuildContext context, ViewModel viewModel) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(viewModel),
        body: mainBody(screenState, viewModel),
      );
    });
  }

  Container mainBody(ScreenState screenState, ViewModel viewModel) {
    Container toReturn;
    switch (screenState) {
      case ScreenState.loading:
        {
          toReturn = loadingMainBody();
          break;
        }
      case ScreenState.error:
        {
          toReturn = errorMainBody();
          break;
        }
      case ScreenState.tasks:
        {
          toReturn = tasksMainBody(viewModel);
          break;
        }
      default:
        {
          toReturn = nullContainer();
        }
    }
    return toReturn;
  }

  Container loadingMainBody() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
        ),
      ),
    );
  }

  Container errorMainBody() {
    return Container(
      child: Center(
        child: Text(
          "Something went wrong!",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Container tasksMainBody(ViewModel viewModel) {
    return viewModel.tasks.length == 0
        ? Container(
            alignment: Alignment.topCenter,
            child: RaisedButton(
              child: Text(
                "+ Add to List",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                createNewTask(viewModel);
              },
              color: Colors.blueAccent,
            ),
          )
        : Container(
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return TaskTile(
                      task: viewModel.tasks[index],
                      store: widget.store,
                      setAppBarLoader: setAppBarLoader,
                    );
                  },
                  itemCount: viewModel.tasks.length,
                )),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      createNewTask(viewModel);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
  }

  AppBar appBar(ViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Todo-List",
            style: TextStyle(color: Colors.white),
          ),
          appBarLoader
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : nullContainer()
        ],
      ),
    );
  }

  void createNewTask(ViewModel viewModel) async {
    String text = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (BuildContext context) {
          return TaskSheet(
            title: "Create new task",
          );
        });
    if (text != null && text != "") {
      setState(() {
        appBarLoader = true;
      });
      bool posted = await createTask(
          store: widget.store,
          userId: viewModel.user.userId.toString(),
          description: text);
      setState(() {
        appBarLoader = false;
      });
      if (!posted) {
        showToast("Something went wrong!");
      }
    }
  }
}

class ViewModel {
  UserModel user;
  List<Task> tasks;
  ViewModel({this.tasks, this.user});

  factory ViewModel.create(Store<AppState> store) {
    return ViewModel(tasks: store.state.tasks, user: store.state.user);
  }
}

enum ScreenState { loading, tasks, error }


import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/ui/bloc_active_task_screen.dart';
import 'package:to_do_app/ui/bloc_archive_task_screen.dart';
import 'package:to_do_app/ui/bloc_done_task_screen.dart';

class TasksStates{

}
class InitTasksState extends TasksStates{

}
class InsertTasksState extends TasksStates{

}
class GetTasksState extends TasksStates{

}
class DeleteTasksState extends TasksStates{

}

class BottomNavigationChangeState extends TasksStates{

}
class BottomSheetChangeState extends TasksStates{

}

class TasksCubit extends Cubit<TasksStates>{
  TasksCubit(TasksStates initialState) : super(initialState);
  static TasksCubit get(context) => BlocProvider.of(context);
  Map<dynamic,dynamic> lastDeletedTask={} ;
  List<Map> activeTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  int bottomNavigationIndex = 0;
  bool isBottomSheetExpanded = false;
  List<String> titles = ["Active", "Done", "Archive"];
  List<Widget> screens = [
    BlocActiveTasksScreen(),
    BlocDoneTasksScreen(),
    BlocArchiveTasksScreen(),
  ];
  void changeBottomNavigationState(int value){
    bottomNavigationIndex = value;
    emit(BottomNavigationChangeState());
  }
  void changeBottomSheetState(bool value){
    isBottomSheetExpanded =value;
    emit(BottomSheetChangeState());
  }

  static late  Database database;
  void openMyDatabase() async {
    database = await openDatabase(
      "tasksDatabase",
      version: 1,
      onCreate: (db, version) async {
        print('onCreate');
        await db.execute(
            "CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)");
      },
      onOpen: (db) {
        print('onOpen');
        database = db;
        getTasks();

      },
    );
  }

  Future<void> insertTask({String? title, String? date,
    required String time}) async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "active")');
      print('RAW INSERT ID => $id');
      // getTasks();
    });
    getTasks();
  }
Future<void> insertDeletedTask({String? title, String? date,
    required String time,required String status}) async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "$status")');
      print('RAW INSERT ID => $id');
      // getTasks();
    });
    getTasks();
  }

  Future<void>  getTasks() async {
    activeTasks = await database.rawQuery('SELECT * FROM Tasks WHERE status = "active"');
    doneTasks = await database.rawQuery('SELECT * FROM Tasks WHERE status = "done"');
    archiveTasks = await database.rawQuery('SELECT * FROM Tasks WHERE status = "archive"');

    var allTasks = await database.rawQuery('SELECT * FROM Tasks');
    print('//////////////////////////////////////////////////////////////////////');
    print(allTasks);
    print('//////////////////////////////////////////////////////////////////////');

    emit(GetTasksState());
  }
  Future<int?> tasksCount() async {
    var count = Sqflite
        .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
    return count;
  }
  Future<void> deleteTask({required int taskId})  async {
    List<Map> get_with_id=await database.rawQuery('SELECT * FROM Tasks WHERE id = ?',[taskId]);
    lastDeletedTask=get_with_id[0];
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [taskId]);
    emit(DeleteTasksState());
    getTasks();
  }

  void updateTask({required String status, required int taskId})  {

    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, taskId]);
    getTasks();
  }

}
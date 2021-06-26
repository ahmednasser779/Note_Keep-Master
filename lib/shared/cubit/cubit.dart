import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/screens/archived_tasks_screen.dart';
import 'package:notekeeper/screens/done_tasks_screen.dart';
import 'package:notekeeper/screens/new_tasks_screen.dart';
import 'package:notekeeper/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // bottom Nav Bar states
  int currentIndex = 0;
  final List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  final List<String> appBarTitles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeBottomNavState(int index){
    currentIndex = index;
    emit(BottomNavBarChangeState());
  }

  // database states
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) => print('Table Created'))
              .catchError((error) => print('Table Failed with error: $error'));
        }, onOpen: (database) {
          print('database opened');
          getDataFromDatabase(database);
        }).then((value) {
          database = value;
          emit(CreateDatabaseState());
    });
  }

  void insertToDatabase(
      {@required String title,
        @required String date,
        @required String time}) async{
   await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(InsertIntoDatabaseState());
        getDataFromDatabase(database);
      })
          .catchError(
              (error) => print('error occured when inserting value: $error'));
      return null;
    });
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      emit(GetFromDatabaseState());
      value.forEach((element) {
        if(element['status']  == 'new'){
          newTasks.add(element);
        }
        else if(element['status']  == 'done'){
          doneTasks.add(element);
        }
        else{
          archivedTasks.add(element);
        }
      });
    });
  }

  void updateDatabase({@required String status, @required int id}){
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          emit(UpdateDatabaseState());
          getDataFromDatabase(database);
    });
  }

  void deleteData({@required int id}) {
    database
        .rawDelete('DELETE FROM Tasks WHERE id = ?', [id])
        .then((value) {
          emit(DeleteFromDatabaseState());
          getDataFromDatabase(database);
    });
  }

  //bottom sheet state
  bool isBottomSheetShown = false;
  void changeBottomSheetState({@required bool isShown}){
    isBottomSheetShown = isShown;
    emit(BottomSheetChangeState());
  }
}
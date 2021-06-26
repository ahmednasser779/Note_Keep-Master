import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/shared/cubit/cubit.dart';
import 'package:notekeeper/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is InsertIntoDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          final cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBarTitles[cubit.currentIndex]),
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavState(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  title: Text('Tasks'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline),
                  title: Text('Done'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  title: Text('Archived'),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.grey[100],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: 'Task Title',
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Title is required!';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                      labelText: 'Task Date',
                                      prefixIcon: Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-06-20'))
                                        .then((value) => dateController.text =
                                            DateFormat.yMMMd().format(value));
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Date is required!';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                      labelText: 'Task Time',
                                      prefixIcon: Icon(Icons.timer),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                            value.format(context));
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Time is required!';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(isShown: false);
                      });
                  cubit.changeBottomSheetState(isShown: true);
                }
              },
              child:
                  cubit.isBottomSheetShown ? Icon(Icons.add) : Icon(Icons.edit),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}

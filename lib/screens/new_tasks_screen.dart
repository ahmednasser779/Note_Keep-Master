import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/shared/components/custom_widgets.dart';
import 'package:notekeeper/shared/cubit/cubit.dart';
import 'package:notekeeper/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var newTasks = AppCubit.get(context).newTasks;
        return newTasks.isEmpty
            ? noTasksWidget(
                iconData: Icons.menu,
                hint: 'You haven\'t Tasks yet, please add new task!')
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildTaskItem(
                      context, newTasks[index], taskStatus.newTask);
                },
                itemCount: newTasks.length,
              );
      },
    );
  }
}

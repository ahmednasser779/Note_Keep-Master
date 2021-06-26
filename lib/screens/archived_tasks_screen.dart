import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/shared/components/custom_widgets.dart';
import 'package:notekeeper/shared/cubit/cubit.dart';
import 'package:notekeeper/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var archivedTasks = AppCubit.get(context).archivedTasks;
        return archivedTasks.isEmpty
            ? noTasksWidget(
                iconData: Icons.archive, hint: 'You haven\'t archived Tasks yet!')
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildTaskItem(
                      context, archivedTasks[index], taskStatus.archivedTask);
                },
                itemCount: archivedTasks.length,
              );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/shared/components/custom_widgets.dart';
import 'package:notekeeper/shared/cubit/cubit.dart';
import 'package:notekeeper/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var doneTasks = AppCubit.get(context).doneTasks;
        return doneTasks.isEmpty
            ? noTasksWidget(
                iconData: Icons.check_circle, hint: 'You haven\'t finished Tasks yet!')
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildTaskItem(
                      context, doneTasks[index], taskStatus.doneTask);
                },
                itemCount: doneTasks.length,
              );
      },
    );
  }
}

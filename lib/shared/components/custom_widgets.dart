import 'package:flutter/material.dart';
import 'package:notekeeper/shared/cubit/cubit.dart';

enum taskStatus { newTask, doneTask, archivedTask }

Widget buildTaskItem(BuildContext context, Map task, var status) {
  return Dismissible(
    key: Key(task['id'].toString()),
    onDismissed: (direction){
      AppCubit.get(context).deleteData(id: task['id']);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 40,
            child: Text(
              task['time'],
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                SizedBox(height: 6),
                Text(
                  task['date'],
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                )
              ],
            ),
          ),
          status == taskStatus.newTask || status == taskStatus.archivedTask
              ? IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateDatabase(status: 'done', id: task['id']);
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                )
              : Container(),
          status == taskStatus.newTask
              ? IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateDatabase(status: 'archived', id: task['id']);
                  },
                  icon: Icon(
                    Icons.archive,
                    color: Colors.black54,
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}

Widget noTasksWidget({@required IconData iconData, @required String hint}){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, color: Colors.black54, size: 120,),
        Text(hint, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black54),)
      ],
    ),
  );
}

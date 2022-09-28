import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/tasks_cubit.dart';
import 'package:to_do_app/components/component.dart';





class BlocArchiveTasksScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksStates>(
    listener: (context,state){

    },
    builder: (context,state){
      TasksCubit cubit=TasksCubit.get(context);
      return tasksListView(cubit.archiveTasks,cubit);
    },
    );
  }
}

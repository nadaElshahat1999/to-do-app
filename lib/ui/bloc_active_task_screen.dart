import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/tasks_cubit.dart';
import 'package:to_do_app/components/component.dart';





class BlocActiveTasksScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksStates>(
    listener: (context,state){

    },
    builder: (context,state){
      TasksCubit cubit=TasksCubit.get(context);
      return (cubit.activeTasks.isEmpty)?
          Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu,color: Colors.grey[400],size: 150,),
              Text('Add new Tasks',style: TextStyle(color: Colors.grey[400],fontSize: 30),),
            ],
          ),)
          :tasksListView(cubit.activeTasks,cubit);
    },
    );
  }
}

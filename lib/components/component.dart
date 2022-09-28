

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/bloc/tasks_cubit.dart';

Widget myTextFormField({
  required TextEditingController controller,
  required FormFieldValidator<String> validator,
  bool passwordVisible = false,
  TextInputType textInputType = TextInputType.text,
  required String label,
  required IconData prefixIcon,
   Widget? suffixIcon,
  GestureTapCallback? onTap,
}) {
  return TextFormField(
    onTap: onTap,
    validator: validator,
    obscureText: passwordVisible,
    controller: controller,
    keyboardType: textInputType,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon),
  );
}

Widget tasksListView(List<Map> tasks, TasksCubit cubit){

  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) => Dismissible(
      key: UniqueKey(),
      onDismissed: (direction){
        if(direction==DismissDirection.endToStart){
          cubit.deleteTask(taskId: tasks[index]['id']);
        }
        if(direction==DismissDirection.startToEnd){
          cubit.deleteTask(taskId: tasks[index]['id']);
        }


      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.grey[300],
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tasks[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        cubit.updateTask(status: 'done', taskId: tasks[index]['id']);
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () {
                        print("sssssssssssssssssssssssssssss");
                        cubit.updateTask(status: 'archive', taskId: tasks[index]['id']);
                      },
                      icon: Icon(
                        Icons.archive,
                        color: Colors.blue,
                      )),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Date : ${tasks[index]["date"]}",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    "Time : ${tasks[index]['time']}",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    ),
  );
}
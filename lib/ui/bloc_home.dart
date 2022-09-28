import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/tasks_cubit.dart';
import 'package:to_do_app/components/component.dart';

import 'bloc_active_task_screen.dart';
import 'bloc_archive_task_screen.dart';
import 'bloc_done_task_screen.dart';

class Bloc_HomeScreen extends StatelessWidget {
  var formkey=GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;
  /*
  _HomeScreenState(){
    print('constructor run---------------------');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state');
    dataBase.openMyDatabase();

  }*/
  @override
  Widget build(BuildContext context) {
    this.context=context;
    print('build run');
    return BlocProvider(create: (context)=> TasksCubit(InitTasksState())..openMyDatabase(),
    child: BlocConsumer<TasksCubit,TasksStates>(
      listener: (context,state){
        print(state);
        if(state is DeleteTasksState){
          scaffoldKey.currentState!.showSnackBar(SnackBar(content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Task deleted successfully'),
              TextButton(onPressed: (){
                TasksCubit cubit=TasksCubit.get(context);
                cubit.insertDeletedTask(time: cubit.lastDeletedTask['time'],
                    date: cubit.lastDeletedTask['date'],title: cubit.lastDeletedTask['title'],
                status: cubit.lastDeletedTask['status']);
              }, child: Text('Undo'))
            ],
          ),duration: Duration(seconds: 2),),);
        }
      },
      builder: (context,state){
        TasksCubit cubit=TasksCubit.get(context);
        return Form(
          key: formkey,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.bottomNavigationIndex]),
            ),
            floatingActionButton: Visibility(
              visible: (cubit.bottomNavigationIndex == 0),
              child: FloatingActionButton(
                onPressed: () {
                  // showSimpleBottomSheet();
                  if(cubit.isBottomSheetExpanded){
                    if (formkey.currentState!.validate()) {
                      String title = titleController.text;
                      String date = dateController.text;
                      String time = timeController.text;
                      Navigator.of(context).pop();
                      cubit.changeBottomSheetState(false);
                      cubit.insertTask(title: title, date: date, time: time).then((value) {
                        cubit.getTasks().then((value) {
                          cubit.screens = [
                            BlocActiveTasksScreen(),
                            BlocDoneTasksScreen(),
                            BlocArchiveTasksScreen(),
                          ];
                          // setState((){});
                        });
                      });

                    }
                  }
                  else{
                    scaffoldKey.currentState!.showBottomSheet((context) => buildBottomSheetItem()).closed.then((value)
                    {
                      cubit.changeBottomSheetState(false);
                      titleController.text='';
                      dateController.text = "";
                      timeController.text = "";
                      //setState(() {});
                    });

                    cubit.changeBottomSheetState(true);
                    //setState(() {});
                  }
                },
                child: cubit.isBottomSheetExpanded ? Icon(Icons.add) : Icon(Icons.edit),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                onTap: (value) {
                  print(value);
                  cubit.changeBottomNavigationState(value);
                  /*cubit.getTasks().then((value) {
                    //setState(() {});
                  });*/

                },
                currentIndex: cubit.bottomNavigationIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: "Active"),
                  BottomNavigationBarItem(icon: Icon(Icons.done_all), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archive"),
                ]),
            body: cubit.screens[cubit.bottomNavigationIndex],
          ),
        );
      },
    ),);
  }

  /*showSimpleBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }*/

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  buildBottomSheetItem() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          myTextFormField(controller: titleController, validator: (value) => titleValidator(titleController.text), label: "Title", prefixIcon: Icons.title),
          SizedBox(height: 10,),
          myTextFormField(controller: dateController,
              validator: (value) => dateValidator(dateController.text), label: "Date", prefixIcon: Icons.date_range
              ,textInputType: TextInputType.none,onTap: (){
                print('date tapped');
                pickDateDialog();
              }),
          SizedBox(height: 10,),
          myTextFormField(controller: timeController,
              validator: (value) => timeValidator(timeController.text), label: "Time", prefixIcon: Icons.timer_outlined
              ,textInputType: TextInputType.none
              ,onTap: (){
                print('date tapped');
                pickTimeDialog();}),
          SizedBox(height: 10,),
        ],),
    );
  }
  void pickDateDialog(){
    int nextYear=DateTime.now().year+1;
    showDatePicker(context: context,
        initialDate: DateTime.now(), firstDate: DateTime(1999),
        lastDate: DateTime(nextYear)).then((PickDate) {
      print('Date picker dialog');
      if(PickDate!=null){
        print(PickDate.toString().split(' ')[0]);
        dateController.text=PickDate.toString().split(' ')[0];
      }
    });
    print('end');
  }

  void pickTimeDialog() async{
    TimeOfDay initialTime=TimeOfDay.now();
    TimeOfDay? pickedTime=await showTimePicker(context: context, initialTime: initialTime,
      builder: (context ,child){
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
    );
    String realHour = (pickedTime!.hour > 12)
        ? "${pickedTime.hour - 12}:${pickedTime.minute} PM"
        : "${pickedTime.hour}:${pickedTime.minute} AM";

    String time = "${realHour}";
    timeController.text = time;
  }



  titleValidator(value){
    if(value!.isEmpty){
      return 'Title required';
    }
    return null;
  }
  dateValidator(value){
    if(value!.isEmpty){
      return 'Date required';
    }
    return null;
  }
  timeValidator(value){
    if(value!.isEmpty){
      return 'Time required';
    }
    return null;
  }

}


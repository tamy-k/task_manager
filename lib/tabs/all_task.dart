import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/logic/db_helper.dart';
import 'package:task/logic/task_model.dart';
import 'package:task/reuseable/all_task_card.dart';

class AllTask extends StatefulWidget{
  const AllTask({Key? key}) : super(key: key);

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  @override
  Widget build(BuildContext context) {
    Future<List<Task>> getTask() async {
      final taskList = await DatabaseProvider.db.getTasks();
      return taskList;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              "Tasks",
              style: TextStyle(
                  color: Color.fromRGBO(32, 75, 90, 1),
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
              future: getTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null) {
                  return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.2),
                          child: Center(
                              child: Text("You don't have any task today",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)))),
                        );
                } else {
                  var list = snapshot.data as List;
                  if (list.isEmpty) {
                    return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.2),
                          child: Center(
                              child: Text("You don't have any task today",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)))),
                        );
                  }
                  return Expanded(
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return AllTaskCard(
                              title: list[index].title,
                              timeRange:
                                  list[index].begin + " - " + list[index].end,
                              color: list[index].color,
                              description: list[index].description,
                              delete: () {
                                // showDialog(context: context, builder: (ctx)=>AlertDialog());
                                DatabaseProvider.db.delete(list[index].id);
                                setState(() {
                                  
                                });
                              },
                            );
                          }));
                }
              }),
        ],
      ),
    );
  }
}

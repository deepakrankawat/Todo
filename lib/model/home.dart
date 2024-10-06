import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/bloc/todo_event.dart';
import 'package:todo/bloc/todo_state.dart';
import 'package:todo/data/todo.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(
          AlterTodo(index),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("My ToDo App")),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();
                return AlertDialog(
                  title: const Text('Add a Task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        decoration: InputDecoration(
                          hintText: 'Task Title...',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: controller2,
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: 'Task Description',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        onPressed: () {
                          addTodo(
                            Todo(
                                title: controller1.text,
                                subtitle: controller2.text),
                          );
                          controller1.text = "";
                          controller2.text = "";
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(Icons.check),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state.status == TodoStatus.success) {
            return ListView.builder(
              itemCount: state.todo.length,
              itemBuilder: (context, int i) {
                return Card(
                  color: Theme.of(context).colorScheme.primary,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Slidable(
                    key: const ValueKey(0),
                    startActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (_) {
                          removeTodo(state.todo[i]);
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        icon: Icons.delete,
                        label: 'Delete',
                      )
                    ]),
                    child: ListTile(
                      title: Text(
                        state.todo[i].title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      subtitle: Text(
                        state.todo[i].subtitle,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      trailing: Checkbox(
                          value: state.todo[i].isDone,
                          onChanged: (value) {
                            alertTodo(i);
                          }),
                    ),
                  ),
                );
              },
            );
          } else if (state.status == TodoStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_3/presentations/screens/loginsignup_screen.dart';
import 'package:flutter_application_3/providers/todo_provider.dart';
import 'package:flutter_application_3/widgets/todoAddCard.dart';
import 'package:flutter_application_3/widgets/todo_card.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _logout() async {
    await context.read<TodoProvider>().logout();

    // After logout, navigate to login screen
    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil("/login", (routes) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-Do"),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  if (todoProvider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    );
                  }

                  final todos = todoProvider.todos;

                  if (todos.isEmpty) {
                    return Center(child: Text("No Todos Found"));
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Dismissible(
                        key: ValueKey(todo.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          final deletedTodo = todo;
                          final deletedIndex = index;
                          context.read<TodoProvider>().todelete(index);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Todo Deleted"),
                              duration: Duration(seconds: 1),
                              action: SnackBarAction(
                                label: "Undo",

                                onPressed: () {
                                  context.read<TodoProvider>().insertTodoAt(
                                    deletedIndex,
                                    deletedTodo,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        background: Container(
                          color: const Color.fromARGB(255, 246, 126, 117),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: TodoCard(
                          title: todo.title,
                          dueDate: DateTime.tryParse(todo.dueDate),
                          isDone: todo.isDone,
                          onChanged: (value) {
                            todoProvider.toggleStatus(index);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Add ToDo"),
                          content: Todoaddcard(),
                        );
                      },
                    );
                  },
                  child: Text("Add ToDo"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

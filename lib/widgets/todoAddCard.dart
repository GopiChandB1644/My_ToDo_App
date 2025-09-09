import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/providers/todo_provider.dart';

class Todoaddcard extends StatefulWidget {
  const Todoaddcard({super.key});

  @override
  State<Todoaddcard> createState() => _TodoaddcardState();
}

class _TodoaddcardState extends State<Todoaddcard> {
  final _titleTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Form(
      key: todoProvider.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleTextEditingController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Title";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Title",
              labelText: "Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: todoProvider.dueDateController,
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select Date";
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  todoProvider.pickDate(context);
                },
                icon: Icon(Icons.calendar_month_outlined),
              ),
              hintText: "Date",
              labelText: "Date",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (todoProvider.formValidator()) {
                await todoProvider.addTodo(_titleTextEditingController.text);
                _titleTextEditingController.clear();
                todoProvider.dueDateController.clear();
                todoProvider.resetDate();
                Navigator.of(context).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

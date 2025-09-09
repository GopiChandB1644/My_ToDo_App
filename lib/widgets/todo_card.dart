import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TodoCard extends StatelessWidget {
  final String? title;
  final DateTime? dueDate;
  final bool? isDone;
  final Function(bool?)? onChanged;
  const TodoCard({
    super.key,
    this.title,
    this.dueDate,
    this.isDone,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset.zero,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${title}"),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  dueDate != null
                      ? DateFormat('yyyy/MM/dd').format(dueDate!)
                      : "No Date",
                ),
                Spacer(),
                Checkbox(value: isDone ?? false, onChanged: onChanged),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

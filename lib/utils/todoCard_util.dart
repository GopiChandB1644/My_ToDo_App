import 'package:flutter/material.dart';

Widget todoCardUtil() {
  //String title;
  return Container(
    padding: EdgeInsets.all(24),
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
        Text("title"),
        SizedBox(height: 5),
        Row(children: [Text("DueDate"), Spacer(), Text("isDone")]),
      ],
    ),
  );
}

class TodoModel {
  String id;
  final String title;
  bool isDone;
  final String dueDate;

  TodoModel({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.dueDate,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return TodoModel(
      id: id,
      title: json['title'] ?? "",
      dueDate: json['dueDate'] ?? "",
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'dueDate': dueDate, 'isDone': isDone};
  }
}

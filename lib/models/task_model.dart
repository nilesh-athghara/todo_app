import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

List<Task> taskListFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskListToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    this.id,
    this.title,
    this.userId,
    this.description,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic title;
  int userId;
  String description;
  DateTime completedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        userId: json["user_id"],
        description: json["description"],
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "user_id": userId,
        "description": description,
        "completed_at":
            completedAt == null ? null : completedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

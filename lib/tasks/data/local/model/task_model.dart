class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? startDateTime;
  final DateTime? stopDateTime;
  final bool completed;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.stopDateTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'startDateTime': startDateTime?.toIso8601String(),
      'stopDateTime': stopDateTime?.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? stopDateTime,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      stopDateTime: stopDateTime ?? this.stopDateTime,
      completed: completed ?? this.completed,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      startDateTime: DateTime.parse(json['startDateTime']),
      stopDateTime: DateTime.parse(json['stopDateTime']),
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, '
        'startDateTime: $startDateTime, stopDateTime: $stopDateTime, '
        'completed: $completed}';
  }
}

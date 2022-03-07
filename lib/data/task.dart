class Task {
  final String date;
  final String title;
  final String subject;

  Task(this.title, this.date, this.subject);

  Task.fromJson(Map<dynamic, dynamic> json)
      : date = json['date'] as String,
        title = json['title'] as String,
        subject = json['subject'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date,
        'title': title,
        'subject': subject,
      };
}

class Notification {
  final String title, subtitle, date;
  final bool isnew;

  const Notification({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.isnew,
  });

  factory Notification.fromJSON(Map<String, dynamic> data) {
    return Notification(
      title: data['title'],
      subtitle: data['subtitle'],
      date: data['date'].toString(),
      isnew: data['new'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJSON() {
    DateTime date = DateTime.now();
    return {
      'title': title.toString(),
      'subtitle': subtitle.toString(),
      'date': date.toString(),
      'new': isnew ? 1 : 0,
    };
  }
}

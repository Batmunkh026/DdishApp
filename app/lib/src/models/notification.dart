class Notification {
  String name;
  String text;
  String imageUrl;
  DateTime date;

  Notification(this.name, this.text, this.imageUrl, this.date);

  Notification.fromJson(Map<String, dynamic> map)
      : this(
          map['notiName'],
          map['notiText'],
          map['notiImgUrl'],
          map['notiDate'] == null ? null : DateTime.parse(map['notiDate']),
        );
}

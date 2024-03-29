class Noti {
  String notificationString;
  String title;
  String body;
  String timeStamp;
  String url;
  bool isRead;

  Noti({
    required this.notificationString,
    this.body = '',
    this.isRead = false,
    this.title = '',
    this.timeStamp = '',
    this.url = '',
  }) {
    final List<String> e = notificationString.split('~');
    title = e[0];
    body = e[1];
    isRead = e[2] != 'u';
    timeStamp = e[3];
    url = e[4];
  }
}

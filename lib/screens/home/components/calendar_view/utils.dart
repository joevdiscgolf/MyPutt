class Event {
  final DateTime dateTime;
  final dynamic item;

  const Event({required this.dateTime, required this.item});
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

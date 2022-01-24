import 'package:intl/intl.dart';

class ModelAlarm {
  final int hour;
  final int minute;
  final bool isAm;
  final bool isActive;

  ModelAlarm({
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.isActive,
  });
}

List<ModelAlarm> alarmList = [];

List<int> openedAt = [];

List<String> labelChartBottom = [];

addLabelChartBottom({required DateTime date}) {
  DateFormat dateFormat = DateFormat('MMM dd\nh:mm:ss ');
  labelChartBottom.add(dateFormat.format(date));
}

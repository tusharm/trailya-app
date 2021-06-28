
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat().add_yMMMd().add_jms();

String formatDate(DateTime datetime) {
  return formatter
      .format(DateTime.fromMillisecondsSinceEpoch(datetime.millisecondsSinceEpoch.toInt()));
}


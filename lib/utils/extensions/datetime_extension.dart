import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime? {
  String? format() {
    if (this == null) return null;
    return DateFormat("dd MMM, yyyy").format(this!.toLocal());
  }
}

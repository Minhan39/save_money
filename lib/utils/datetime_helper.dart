import 'package:intl/intl.dart';

String convertDate(DateTime date, {String format = 'dd/MM/yyyy'}) =>
    DateFormat(format).format(date);

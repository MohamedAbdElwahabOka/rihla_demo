import 'package:intl/intl.dart';

/// Formats an amount as EUR per NFR-026, e.g. `€ 1,900`.
String formatEur(num amount) => '€ ${NumberFormat('#,##0').format(amount)}';

/// Formats a date per NFR-025, e.g. `20/07/2026`.
String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

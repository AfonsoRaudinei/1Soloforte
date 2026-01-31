import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_dap.g.dart';

class CalculateDap {
  int call(DateTime plantingDate, DateTime targetDate) {
    if (targetDate.isBefore(plantingDate)) return 0;
    return targetDate.difference(plantingDate).inDays;
  }
}

@riverpod
CalculateDap calculateDap(Ref ref) {
  return CalculateDap();
}

import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:expenses/log/log_totals_model/log_total.dart';
import 'package:meta/meta.dart';

@immutable
class LogTotalsState extends Equatable {
  final Map<String, LogTotal> logTotals;

  LogTotalsState({this.logTotals});

  @override
  List<Object> get props => [logTotals];

  factory LogTotalsState.initial() {
    return LogTotalsState(
      logTotals: LinkedHashMap(),
    );
  }

  @override
  bool get stringify => true;

  LogTotalsState copyWith({
    Map<String, LogTotal> logTotals,
  }) {
    if ((logTotals == null || identical(logTotals, this.logTotals))) {
      return this;
    }

    return new LogTotalsState(
      logTotals: logTotals ?? this.logTotals,
    );
  }
}
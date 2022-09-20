// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';

class LogBookState extends Equatable {
  final List<LogbookEntry> entries;
  final bool isLoading;
  LogBookState({
    this.isLoading = false,
    this.entries = const [],
  });

  @override
  List<Object?> get props => [entries, isLoading];

  LogBookState copyWith({
    List<LogbookEntry>? entries,
    bool? isLoading,
  }) {
    return LogBookState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';

class LogBookState extends Equatable {
  final List<LogbookEntry> entries;
  final List<String> headers;
  final bool isLoading;
  LogBookState({
    this.entries = const [],
    this.headers = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [entries, isLoading, headers];

  LogBookState copyWith({
    List<LogbookEntry>? entries,
    List<String>? headers,
    bool? isLoading,
  }) {
    return LogBookState(
      entries: entries ?? this.entries,
      headers: headers ?? this.headers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

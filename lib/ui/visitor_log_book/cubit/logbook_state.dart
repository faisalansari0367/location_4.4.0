// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';

class LogBookState extends Equatable {
  final List<LogbookEntry> entries;
  final List<String> headers;
  final bool isLoading;
  final int limit;
  final int page;
  final bool hasReachedMax;

  const LogBookState({
    this.hasReachedMax = false,
    this.entries = const [],
    this.headers = const [],
    this.isLoading = false,
    this.limit = 20,
    this.page = 1,
  });

  @override
  List<Object?> get props => [entries, isLoading, headers, page, limit, hasReachedMax];

  LogBookState copyWith({
    List<LogbookEntry>? entries,
    List<String>? headers,
    bool? isLoading,
    int? limit,
    int? page,
    bool? hasReachedMax,
  }) {
    return LogBookState(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      entries: entries ?? this.entries,
      headers: headers ?? this.headers,
      isLoading: isLoading ?? this.isLoading,
      limit: limit ?? this.limit,
      page: page ?? this.page,
    );
  }
}

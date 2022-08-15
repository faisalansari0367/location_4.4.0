// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DrawerState extends Equatable {
  final AnimationController? controller;
  final bool isOpen;
  final int currentPage;

  DrawerState({
    this.controller,
    this.isOpen = false,
    this.currentPage = 0,
  });

  @override
  List<Object?> get props => [controller, isOpen, currentPage];

  DrawerState copyWith({
    AnimationController? controller,
    bool? isOpen,
    int? currentPage,
  }) {
    return DrawerState(
      controller: controller ?? this.controller,
      isOpen: isOpen ?? this.isOpen,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

import 'package:flutter/material.dart';

enum ToastType {
  generic,
}

class GenericToastMetadata {
  GenericToastMetadata({
    required this.message,
    this.icon,
    this.iconSize = 24,
  });

  final String message;
  final Widget? icon;
  final double iconSize;
}

class ToastData {
  ToastData({required this.toastType, required this.metadata});
  ToastType toastType;
  dynamic metadata;
}

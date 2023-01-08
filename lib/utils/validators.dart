import 'package:flutter/material.dart';

bool validUsername(String? value) {
  if (value == null ||
      value.trim().length < 3 ||
      value.trim().length > 20 ||
      value.trim().contains(' ')) {
    return false;
  }
  return true;
}

TextEditingValue validatePositiveInteger(String oldVal, String newVal) {
  String valueToSet;

  final int? number = int.tryParse(newVal);

  if (number != null && number >= 0) {
    valueToSet = newVal;
  } else {
    valueToSet = oldVal;
  }

  return TextEditingValue(
    text: valueToSet,
    selection: TextSelection.fromPosition(
      TextPosition(offset: valueToSet.length),
    ),
  );
}

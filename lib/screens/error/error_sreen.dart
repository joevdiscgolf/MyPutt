import 'package:flutter/material.dart';
import 'package:myputt/components/empty_state/empty_state.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyState(
        onRetry: () {},
      ),
    );
  }
}

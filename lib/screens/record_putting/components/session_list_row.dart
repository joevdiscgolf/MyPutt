import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_session.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow({Key? key, required this.session}) : super(key: key);
  final PuttingSession session;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(session.dateStarted, style: textStyle),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_session.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow({Key? key, required this.session, this.index})
      : super(key: key);
  final PuttingSession session;
  final int? index;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('${index ?? '0'}: ${session.dateStarted}', style: textStyle),
          ],
        ),
      ),
    );
  }
}

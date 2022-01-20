import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_set.dart';

class PuttingSetRow extends StatelessWidget {
  const PuttingSetRow({Key? key, required this.set}) : super(key: key);
  final PuttingSet set;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('${set.puttsMade}/${set.puttsAttempted}', style: textStyle),
            const SizedBox(width: 100),
            Text('${set.distance}', style: textStyle),
          ],
        ),
      ),
    );
  }
}

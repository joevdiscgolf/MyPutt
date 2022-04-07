import 'package:flutter/material.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row.dart';

class PreviousSetsList extends StatefulWidget {
  const PreviousSetsList(
      {Key? key,
      required this.static,
      required this.sets,
      required this.deleteSet,
      required this.deletable})
      : super(key: key);

  final List<PuttingSet> sets;
  final Function deleteSet;
  final bool deletable;
  final bool static;

  @override
  _PreviousSetsListState createState() => _PreviousSetsListState();
}

class _PreviousSetsListState extends State<PreviousSetsList> {
  @override
  Widget build(BuildContext context) {
    return widget.sets.isEmpty
        ? const Center(child: Text('No sets yet'))
        : ListView(
            children: List.from(widget.sets
                .asMap()
                .entries
                .map((entry) {
                  return PuttingSetRow(
                      deletable: widget.deletable,
                      set: entry.value,
                      index: entry.key,
                      delete: () {
                        widget.deleteSet(entry.value);
                      });
                })
                .toList()
                .reversed),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/putting_set_row.dart';
import 'package:myputt/cubits/challenges_cubit.dart';

class ChallengePreviousSetsList extends StatefulWidget {
  const ChallengePreviousSetsList(
      {Key? key,
      required this.sets,
      required this.deleteSet,
      required this.deletable})
      : super(key: key);

  final List<PuttingSet> sets;
  final Function deleteSet;
  final bool deletable;

  @override
  _ChallengePreviousSetsListState createState() =>
      _ChallengePreviousSetsListState();
}

class _ChallengePreviousSetsListState extends State<ChallengePreviousSetsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is! ChallengesErrorState) {
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
      } else {
        return Container();
      }
    });
  }
}

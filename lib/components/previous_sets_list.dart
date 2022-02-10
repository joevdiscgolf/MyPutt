import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/putting_set_row.dart';
import 'package:myputt/bloc/cubits/challenges_cubit.dart';

class PreviousSetsList extends StatefulWidget {
  const PreviousSetsList({Key? key, required this.sets}) : super(key: key);

  final List<PuttingSet> sets;

  @override
  _PreviousSetsListState createState() => _PreviousSetsListState();
}

class _PreviousSetsListState extends State<PreviousSetsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is ChallengeInProgress) {
        return Flexible(
          fit: FlexFit.loose,
          child: widget.sets.isEmpty
              ? const Center(child: Text('No sets yet'))
              : ListView(
                  children: List.from(widget.sets
                      .asMap()
                      .entries
                      .map((entry) => PuttingSetRow(
                          deletable: true,
                          set: entry.value,
                          index: entry.key,
                          delete: () {
                            /*BlocProvider.of<ChallengesCubit>(context)
                                .deleteSet(entry.value);*/
                          }))
                      .toList()
                      .reversed),
                ),
        );
      } else if (state is ChallengeComplete) {
        return Flexible(
          fit: FlexFit.loose,
          child: widget.sets.isEmpty
              ? const Center(child: Text('No sets yet'))
              : ListView(
                  children: List.from(widget.sets
                      .asMap()
                      .entries
                      .map((entry) => PuttingSetRow(
                          deletable: true,
                          set: entry.value,
                          index: entry.key,
                          delete: () {
                            /*BlocProvider.of<ChallengesCubit>(context)
                                .deleteSet(entry.value);*/
                          }))
                      .toList()
                      .reversed),
                ),
        );
      }
      return Container();
    });
  }
}

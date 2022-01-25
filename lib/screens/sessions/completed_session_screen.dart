import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:myputt/screens/record/components/putting_set_row.dart';

class CompletedSessionScreen extends StatefulWidget {
  const CompletedSessionScreen({Key? key, required this.session})
      : super(key: key);

  final PuttingSession session;

  @override
  _CompletedSessionScreenState createState() => _CompletedSessionScreenState();
}

class _CompletedSessionScreenState extends State<CompletedSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100]!,
      appBar: AppBar(
        title: Text(widget.session.dateStarted),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _summaryBox(context),
          _setsList(context),
        ],
      ),
    );
  }

  Widget _summaryBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.session.dateStarted,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${widget.session.sets.length.toString()} sets',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text('Circle 1'),
                      Text('70 %'),
                    ],
                  ),
                  Column(
                    children: const [
                      Text('Circle 2'),
                      Text('40 %'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Putts'),
                      Text(
                          '${widget.session.totalPuttsMade} / ${widget.session.totalPuttsAttempted}'),
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _setsList(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: widget.session.sets.isEmpty
          ? const Center(child: Text('No sets yet'))
          : ListView(
              children: List.from(widget.session.sets
                  .asMap()
                  .entries
                  .map((entry) => PuttingSetRow(
                      set: entry.value,
                      index: entry.key,
                      deletable: false,
                      delete: () {
                        BlocProvider.of<SessionsCubit>(context)
                            .deleteSet(entry.value);
                      }))
                  .toList()
                  .reversed),
            ),
    );
  }
}

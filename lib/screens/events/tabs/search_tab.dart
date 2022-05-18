import 'package:flutter/material.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/utils/colors.dart';

import 'package:myputt/utils/constants.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchBarController = TextEditingController();
  String? _searchBarText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyPuttColors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: _searchBar(context),
            pinned: true,
            backgroundColor: MyPuttColors.white,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    EventsList(events: kTestEvents),
                childCount: 1),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _searchBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: _searchBarController,
          autocorrect: false,
          maxLines: 1,
          maxLength: 24,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Event name',
            contentPadding:
                const EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
            isDense: true,
            hintStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: MyPuttColors.gray[400], fontSize: 18),
            enabledBorder: Theme.of(context).inputDecorationTheme.border,
            focusedBorder: Theme.of(context).inputDecorationTheme.border,
            counter: const Offstage(),
          ),
          onChanged: (String text) => setState(() => _searchBarText = text),
        ),
      ),
    );
  }
}

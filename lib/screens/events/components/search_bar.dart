import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.searchBarController})
      : super(key: key);

  final TextEditingController searchBarController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: searchBarController,
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
      ),
    );
  }
}

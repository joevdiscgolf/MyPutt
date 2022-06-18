import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/exit_button.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        AutoSizeText(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ExitButton(),
          ),
        ),
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/data/endpoints/events/event_endpoints.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/event_detail/components/dialogs/division_chip.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class JoinEventDialog extends StatefulWidget {
  const JoinEventDialog(
      {Key? key, required this.event, required this.onEventJoin})
      : super(key: key);

  final MyPuttEvent event;
  final Function onEventJoin;

  @override
  _JoinEventDialogState createState() => _JoinEventDialogState();
}

class _JoinEventDialogState extends State<JoinEventDialog> {
  final EventsService _eventsService = locator.get<EventsService>();

  final TextEditingController _codeFieldController = TextEditingController();
  String? code;
  String? _dialogErrorText;
  bool _loading = false;
  Division? _selectedDivision;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(top: 24, bottom: 16, left: 24, right: 24),
          width: double.infinity,
          child: _mainBody(context),
        ));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            'Join ${widget.event.name}',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          Wrap(
              children: widget.event.divisions
                  .map((division) => DivisionChip(
                      division: division,
                      onPressed: (Division division) =>
                          setState(() => _selectedDivision = division),
                      selected: _selectedDivision == division))
                  .toList()),
          // const Icon(
          //   FlutterRemix.user_add_line,
          //   color: MyPuttColors.blue,
          //   size: 40,
          // ),
          const SizedBox(height: 16),
          _codeField(context),
          const SizedBox(height: 8),
          Text(
            _dialogErrorText ?? '',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkRed, fontSize: 12),
          ),
          const SizedBox(height: 16),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            loading: _loading,
            title: 'Join',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            color: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: _joinPressed,
          ),
          MyPuttButton(
              width: 100,
              height: 40,
              title: 'Cancel',
              textSize: 12,
              textColor: Colors.grey[600]!,
              color: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Widget _codeField(BuildContext context) {
    return TextFormField(
      controller: _codeFieldController,
      autocorrect: false,
      maxLines: 1,
      maxLength: 24,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Code',
        contentPadding:
            const EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: TWUIColors.gray[400], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
        counter: const Offstage(),
      ),
      onChanged: (String text) => setState(() => code = text),
    );
  }

  void _joinPressed() async {
    if (_selectedDivision == null) {
      setState(() => _dialogErrorText = 'Select a division');
      return;
    }

    final String inputText = _codeFieldController.text;
    if (int.tryParse(inputText) == null) {
      setState(() {
        _dialogErrorText = 'Enter a valid number';
        _loading = false;
      });
      return;
    }

    final int code = int.parse(inputText);
    setState(() => _loading = true);
    final JoinEventResponse response =
        await _eventsService.joinEventWithCode(code, _selectedDivision!);
    if (response.success) {
      widget.onEventJoin();
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';

class ExitEventDialog extends StatefulWidget {
  const ExitEventDialog(
      {Key? key, required this.event, required this.onEventExit})
      : super(key: key);

  final MyPuttEvent event;
  final Function onEventExit;

  @override
  _ExitEventDialogState createState() => _ExitEventDialogState();
}

class _ExitEventDialogState extends State<ExitEventDialog> {
  final EventsService _eventsService = locator.get<EventsService>();

  String? code;
  String? _dialogErrorText;
  bool _loading = false;

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
            'Exit ${widget.event.name}',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          const ShadowIcon(
            icon: Icon(
              FlutterRemix.alert_line,
              color: MyPuttColors.red,
              size: 60,
            ),
          ),
          const SizedBox(height: 16),
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
            title: 'Exit',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            color: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: _exitPressed,
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

  void _exitPressed() async {
    setState(() => _loading = true);
    final bool success = await _eventsService
        .exitEvent(widget.event.id)
        .then((response) => response.success);
    if (success) {
      widget.onEventExit();
    }
    Navigator.of(context).pop();
    setState(() => _loading = false);
  }
}

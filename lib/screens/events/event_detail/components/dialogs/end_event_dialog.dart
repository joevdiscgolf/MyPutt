import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';

class EndEventDialog extends StatefulWidget {
  const EndEventDialog({Key? key, required this.eventId}) : super(key: key);

  final String eventId;

  @override
  State<EndEventDialog> createState() => _EndEventDialogState();
}

class _EndEventDialogState extends State<EndEventDialog> {
  final EventsService _eventsService = locator.get<EventsService>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();

  late Future<void> _fetchData;
  List<EventPlayerData>? _allStandings;
  bool _error = false;
  ButtonState _buttonState = ButtonState.normal;

  Future<void> _initData() async {
    try {
      await _databaseService
          .loadEventStandings(widget.eventId)
          .then((standings) => setState(() => _allStandings = standings));
    } catch (e) {
      setState(() {
        _error = true;
      });
      return;
    }
  }

  @override
  void initState() {
    _fetchData = _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          top: 24,
          bottom: 16,
          left: 24,
          right: 24,
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_mainBody()],
        ),
      ),
    );
  }

  Widget _mainBody() {
    return FutureBuilder<void>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_error || _allStandings == null) {
              return EmptyState(
                title: 'Something went wrong.',
                subtitle: 'Please try again',
                onRetry: () => _fetchData = _initData(),
              );
            }
            final List<EventPlayerData> incompletePlayers =
                _getIncompletePlayers(_allStandings!);

            return Column(
              children: [
                AutoSizeText(
                  'Finish event',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                const Icon(FlutterRemix.check_line, size: 40),
                const SizedBox(height: 16),
                AutoSizeText(
                  'This will lock players out of continuing the event.',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: MyPuttColors.gray[400], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (incompletePlayers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                      '${incompletePlayers.length} ${incompletePlayers.length == 1 ? 'player has' : 'players have'} not completed the event.'),
                ],
                const SizedBox(height: 16),
                MyPuttButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                  title: 'Finish',
                  textSize: 18,
                  height: 40,
                  borderColor: MyPuttColors.blue,
                  backgroundColor: MyPuttColors.white,
                  textColor: MyPuttColors.blue,
                  shadowColor: MyPuttColors.gray[300]!,
                  onPressed: () async {
                    setState(() {
                      _buttonState = ButtonState.loading;
                    });
                    final bool success =
                        await _eventsService.endEvent(widget.eventId);
                    if (!mounted) {
                      return;
                    }
                    if (success) {
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      setState(() {
                        _buttonState = ButtonState.retry;
                      });
                    }
                  },
                  buttonState: _buttonState,
                ),
                MyPuttButton(
                    width: 100,
                    height: 40,
                    title: 'Cancel',
                    textSize: 12,
                    textColor: Colors.grey[600]!,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );

          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  List<EventPlayerData> _getIncompletePlayers(
      List<EventPlayerData> allPlayers) {
    return allPlayers.where((player) => !player.lockedIn).toList();
  }
}

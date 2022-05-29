import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/screens/events/event_detail/components/dialogs/exit_event_dialog.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_loading_screen.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_panel.dart';
import 'package:myputt/screens/events/event_detail/components/player_list.dart';
import 'package:myputt/screens/events/event_record/event_record_screen.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/panel_helpers.dart';

import 'components/dialogs/join_event_dialog.dart';
import 'components/panels/update_division_panel.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final EventsService _eventsService = locator.get<EventsService>();
  late Division _division;
  List<EventPlayerData>? _eventStandings;
  late Future<void> _fetchData;
  bool _inEvent = false;
  late final StreamSubscription? _scoreUpdatesSubscription;

  @override
  void initState() {
    _eventsRepository.initializeEventStream(widget.event.eventId);
    _division = widget.event.divisions.first;
    _fetchData = _initData();
    _scoreUpdatesSubscription = _eventsRepository.playerDataStream
        ?.listen((List<EventPlayerData> standings) {
      setState(() => _eventStandings = standings);
    });

    super.initState();
  }

  @override
  void dispose() {
    _scoreUpdatesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initData() async {
    await _eventsService
        .getEvent(widget.event.eventId, division: _division)
        .then((response) => setState(() {
              _eventStandings = response.eventStandings;
              _inEvent = response.inEvent;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButton: _inEvent ? _competeButton(context) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: MyPuttColors.white,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, _) => [
                  _sliverAppBar(context),
                ],
            body: FutureBuilder<void>(
              future: _fetchData,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                // return const EventDetailLoadingScreen();
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (_eventStandings == null) {
                      return EmptyState(
                          onRetry: () => _fetchData = _initData());
                    }
                    if (_eventStandings!.isEmpty) {
                      return EmptyState(
                        title: 'Nothing here yet',
                        subtitle: 'Please try again later',
                        icon: Icon(
                          FlutterRemix.stack_line,
                          color: MyPuttColors.gray[400]!,
                          size: 40,
                        ),
                      );
                    }
                    return PlayerList(
                        eventStandings: _eventStandings!,
                        challengeStructure: widget.event.challengeStructure);
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  default:
                    return const EventDetailLoadingScreen();
                }
              },
            )),
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      actions: [
        _joinLeaveButton(context),
      ],
      backgroundColor: Colors.white,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: AppBarBackButton(),
      ),
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      elevation: 0,
      toolbarHeight: 48,
      leadingWidth: 48,
      expandedHeight: 300,
      collapsedHeight: 56,
      flexibleSpace: FlexibleSpaceBar(
          background: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: widget.event.bannerImgUrl != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.srcOver),
                  image: NetworkImage(widget.event.bannerImgUrl!))
              : DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.srcOver),
                  image: const AssetImage(defaultEventImgPath)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventDetailsPanel(
              event: widget.event,
              onDivisionUpdate: (Division updatedDivision) {
                setState(() => _division = updatedDivision);
              },
              division: _division,
              textColor: MyPuttColors.white,
            ),
          ],
        ),
      )
          // : Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const SizedBox(height: 100),
          //       EventDetailsPanel(
          //         event: widget.event,
          //         onDivisionUpdate: (Division updatedDivision) {
          //           setState(() => _division = updatedDivision);
          //         },
          //         division: _division,
          //       ),
          //     ],
          //   ),
          ),
      bottom: _sliverBarBottom(context),
      title: CollapsingAppBarTitle(
        child: Text(
          'Summer Sizzler',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.darkGray),
        ),
      ),
    );
  }

  Widget _descriptionRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: AutoSizeText(
                'POS',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: MyPuttColors.darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            child: SizedBox(
              width: 48,
              child: AutoSizeText(
                'NAME',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: MyPuttColors.darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                maxLines: 1,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
              width: 64,
              child: FittedBox(
                child: Text(
                  'PUTTS MADE',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: MyPuttColors.darkGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              )),
          const SizedBox(width: 52),
        ],
      ),
    );
  }

  PreferredSizeWidget _sliverBarBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
            color: MyPuttColors.white,
            border: Border(bottom: BorderSide(color: MyPuttColors.gray[200]!))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: _changeDivisionButton(context)),
            const SizedBox(height: 8),
            _descriptionRow(context),
          ],
        ),
      ),
    );
  }

  Widget _changeDivisionButton(BuildContext context) {
    return Bounceable(
        onTap: () => displayBottomSheet(
            context,
            UpdateDivisionPanel(
                currentDivision: _division,
                availableDivisions: widget.event.divisions,
                onDivisionUpdate: (Division division) {
                  setState(() => _division = division);
                  _fetchData = _initData();
                })),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: MyPuttColors.darkBlue)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _division.name.toUpperCase(),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: MyPuttColors.darkBlue,
                      fontSize: 14,
                    ),
              ),
              const Icon(FlutterRemix.arrow_down_s_line,
                  color: MyPuttColors.darkBlue, size: 16)
            ],
          ),
        ));
  }

  Widget _competeButton(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state is! ActiveEventState) {
          return Container();
        }
        final double percentComplete =
            state.eventPlayerData.sets.length.toDouble() /
                state.event.challengeStructure.length.toDouble();

        return Bounceable(
            onTap: () {
              Vibrate.feedback(FeedbackType.light);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: MyPuttColors.gray[100]!),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(
                        MediaQuery.of(context).size.width /
                            2 *
                            -((1 - percentComplete) / 2),
                        0),
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width /
                          2 *
                          percentComplete,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: MyPuttColors.skyBlue),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MyPuttButton(
                      onPressed: () {
                        BlocProvider.of<EventsCubit>(context)
                            .openEvent(widget.event);
                        displayBottomSheet(
                          context,
                          EventRecordScreen(event: widget.event),
                          dismissibleOnTap: true,
                          enableDrag: false,
                          onDismiss: () => _fetchData = _initData(),
                        );
                      },
                      title:
                          '${((state.eventPlayerData.sets.length.toDouble() / state.event.challengeStructure.length.toDouble()) * 100).toStringAsFixed(0)}% complete',
                      iconData: FlutterRemix.sword_fill,
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 48,
                      textColor: MyPuttColors.darkGray,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _joinLeaveButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                if (!_inEvent) {
                  return JoinEventDialog(
                    event: widget.event,
                    onEventJoin: () => setState(() => _inEvent = true),
                  );
                }
                return ExitEventDialog(
                    event: widget.event,
                    onEventExit: () => setState(() => _inEvent = false));
              }).then((_) => _fetchData = _initData());
        },
        icon: Icon(
          _inEvent ? FlutterRemix.logout_box_line : FlutterRemix.user_add_line,
          color: MyPuttColors.white,
        ));
  }
}

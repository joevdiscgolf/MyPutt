import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/cubits/events/event_standings_cubit.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/event_detail/components/compete_button.dart';
import 'package:myputt/screens/events/event_detail/components/dialogs/exit_event_dialog.dart';
import 'package:myputt/screens/events/event_detail/components/dialogs/end_event_dialog.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_loading_screen.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_panel.dart';
import 'package:myputt/screens/events/event_detail/components/player_list.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/event_helpers.dart';
import 'package:myputt/utils/panel_helpers.dart';

import 'components/dialogs/join_event_dialog.dart';
import 'components/panels/update_division_panel.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key, required this.event, this.onEventUpdate})
      : super(key: key);

  final MyPuttEvent event;
  final Function(MyPuttEvent)? onEventUpdate;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late final EventDetailCubit _eventDetailCubit;
  late final EventStandingsCubit _eventStandingsCubit;
  final EventsService _eventsService = locator.get<EventsService>();
  late Division _division;
  bool _inEvent = false;
  late bool _isAdmin;

  Future<void> _refreshData() async {
    await Future.wait(
      [
        _loadDivisionStandings(),
        BlocProvider.of<EventDetailCubit>(context)
            .reloadEventDetails(widget.event.eventId)
      ],
    );
  }

  Future<void> _loadDivisionStandings() async {
    await BlocProvider.of<EventStandingsCubit>(context).loadDivisionStandings(
      widget.event.eventId,
      _division,
    );
  }

  Future<void> _loadIsInEvent() async {
    await _eventsService
        .isInEvent(widget.event.eventId)
        .then((bool isInEvent) => setState(() => _inEvent = isInEvent));
  }

  @override
  void dispose() {
    _eventDetailCubit.exitEventScreen();
    _eventStandingsCubit.exitEventScreen();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _eventDetailCubit = BlocProvider.of<EventDetailCubit>(context);
    _eventStandingsCubit = BlocProvider.of<EventStandingsCubit>(context);

    _loadIsInEvent();
    _isAdmin = isEventAdmin(widget.event);
    _division = widget.event.eventCustomizationData.divisions.first;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: MyPuttColors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _sliverAppBar(context),
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await _refreshData();
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return BlocConsumer<EventDetailCubit, EventDetailState>(
                        listenWhen: (previous, current) =>
                            current is EventDetailLoaded,
                        listener: (context, updatedState) {
                          if (updatedState is EventDetailLoaded) {
                            if (widget.onEventUpdate != null) {
                              widget.onEventUpdate!(updatedState.event);
                            }
                          }
                        },
                        builder: (context, detailState) {
                          return BlocBuilder<EventStandingsCubit,
                              EventStandingsState>(
                            builder: (context, standingsState) {
                              if (standingsState is EventStandingsLoading) {
                                return const EventStandingsLoadingScreen();
                              } else if (standingsState
                                  is EventStandingsError) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: EmptyState(
                                    onRetry: () async =>
                                        await _loadDivisionStandings(),
                                  ),
                                );
                              } else {
                                final EventStandingsLoaded loadedState =
                                    standingsState as EventStandingsLoaded;
                                if (loadedState.divisionStandings.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: const Column(
                                      children: [
                                        Icon(FlutterRemix.stack_line, size: 40),
                                        SizedBox(height: 8),
                                        Text('No players yet'),
                                      ],
                                    ),
                                  );
                                }
                                final bool isComplete =
                                    detailState is EventDetailLoaded &&
                                        detailState.event.status ==
                                            EventStatus.complete;

                                return PlayerList(
                                  eventStandings: loadedState.divisionStandings,
                                  challengeStructure: widget
                                      .event
                                      .eventCustomizationData
                                      .challengeStructure,
                                  isComplete: isComplete,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                    childCount: 1,
                  ),
                )
              ],
            ),
            if (_inEvent)
              Align(
                alignment: Alignment.bottomCenter,
                child: CompeteButton(event: widget.event),
              ),
          ],
        ),
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
                        Colors.black.withOpacity(0.3), BlendMode.srcOver),
                    image: const AssetImage(kDefaultEventImgPath)),
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
        ),
      ),
      bottom: _sliverBarBottom(context),
      title: CollapsingAppBarTitle(
        child: Text(
          'Summer Sizzler',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: MyPuttColors.darkGray),
        ),
      ),
    );
  }

  Widget _descriptionRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: AutoSizeText(
                'POS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: MyPuttColors.darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  PreferredSizeWidget _sliverBarBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: MyPuttColors.white,
          border: Border(
            bottom: BorderSide(
              color: MyPuttColors.gray[200]!,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _changeDivisionButton(context),
                  ),
                  if (_isAdmin) ...[
                    const Spacer(),
                    Bounceable(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              EndEventDialog(eventId: widget.event.eventId),
                        );
                      },
                      child: const Icon(
                        FlutterRemix.pencil_line,
                        color: MyPuttColors.blue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
                availableDivisions:
                    widget.event.eventCustomizationData.divisions,
                onDivisionUpdate: (Division division) async {
                  setState(() => _division = division);
                  await _loadDivisionStandings();
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _joinLeaveButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        _joinOrLeave(context);
      },
      icon: Icon(
        _inEvent ? FlutterRemix.logout_box_line : FlutterRemix.user_add_line,
        color: MyPuttColors.white,
      ),
    );
  }

  void _joinOrLeave(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (!_inEvent) {
          return JoinEventDialog(
            event: widget.event,
            onEventJoin: () {
              setState(() => _inEvent = true);
              BlocProvider.of<EventDetailCubit>(context)
                  .openEvent(widget.event);
            },
          );
        } else {
          return ExitEventDialog(
            event: widget.event,
            onEventExit: () => setState(() => _inEvent = false),
          );
        }
      },
    );
  }
}

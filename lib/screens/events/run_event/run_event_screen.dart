import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/cubits/events/event_run_cubit.dart';
import 'package:myputt/cubits/events/event_standings_cubit.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_loading_screen.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_panel.dart';
import 'package:myputt/screens/events/event_detail/components/panels/update_division_panel.dart';
import 'package:myputt/screens/events/event_detail/components/player_list.dart';
import 'package:myputt/screens/events/run_event/components/end_event_dialog.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/panel_helpers.dart';

class RunEventScreen extends StatefulWidget {
  const RunEventScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  State<RunEventScreen> createState() => _RunEventScreenState();
}

class _RunEventScreenState extends State<RunEventScreen> {
  late Division _division;

  Future<void> _refreshDivisionStandings() async {
    await BlocProvider.of<EventStandingsCubit>(context).loadDivisionStandings(
      widget.event.eventId,
      _division,
    );
  }

  @override
  void initState() {
    _division = widget.event.eventCustomizationData.divisions.first;
    BlocProvider.of<EventStandingsCubit>(context).openEvent(
      widget.event.eventId,
      _division,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _endEventButton(),
        backgroundColor: MyPuttColors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _sliverAppBar(context),
                CupertinoSliverRefreshControl(onRefresh: () async {
                  await _refreshDivisionStandings();
                }),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return BlocBuilder<EventStandingsCubit,
                          EventStandingsState>(
                        builder: (context, state) {
                          if (state is EventStandingsLoading) {
                            return const EventStandingsLoadingScreen();
                          } else if (state is EventStandingsError) {
                            return Container(
                              padding: const EdgeInsets.only(top: 24),
                              child: EmptyState(
                                onRetry: () async =>
                                    await _refreshDivisionStandings(),
                              ),
                            );
                          } else {
                            final EventStandingsLoaded loadedState =
                                state as EventStandingsLoaded;
                            if (loadedState.divisionStandings.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.only(top: 24),
                                child: Column(
                                  children: const [
                                    Icon(
                                      FlutterRemix.stack_line,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text('No players yet'),
                                  ],
                                ),
                              );
                            }
                            return PlayerList(
                              eventStandings: loadedState.divisionStandings,
                              challengeStructure: widget.event
                                  .eventCustomizationData.challengeStructure,
                            );
                          }
                        },
                      );
                    },
                    childCount: 1,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
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
                availableDivisions:
                    widget.event.eventCustomizationData.divisions,
                onDivisionUpdate: (Division division) {
                  setState(() => _division = division);
                  _refreshDivisionStandings();
                },
              ),
            ),
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

  Widget _endEventButton() {
    return BlocBuilder<EventStandingsCubit, EventStandingsState>(
      builder: (context, state) {
        EventStandingsLoaded? loadedState;

        if (state is EventStandingsLoaded) {
          loadedState = state;
        }

        return MyPuttButton(
          width: 128,
          title: 'End event',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  EndEventDialog(eventId: widget.event.eventId),
            );
          },
        );
      },
    );
  }
}

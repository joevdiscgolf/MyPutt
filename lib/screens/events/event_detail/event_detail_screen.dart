import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/components/event_detail_app_bar.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_panel.dart';
import 'package:myputt/screens/events/event_detail/components/player_data_row.dart';
import 'package:myputt/screens/events/event_detail/components/player_list.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventsService _eventsService = locator.get<EventsService>();
  // late Future<void> _fetchData;
  late List<EventPlayerData>? _eventStandings;

  Division division = Division.mpo;

  // @override
  // void initState() {
  //   _fetchData = _initData();
  //   super.initState();
  // }
  //
  // Future<void> _initData() async {
  //   await _eventsService
  //       .getEventStandings(widget.event.id)
  //       .then((response) => _eventStandings = response.eventStandings);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventDetailAppBar(
        title: widget.event.name,
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, _) => [
                SliverToBoxAdapter(
                  child: EventDetailsPanel(
                    event: widget.event,
                    onDivisionUpdate: (Division updatedDivision) {
                      setState(() => division = updatedDivision);
                    },
                    division: division,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                )
                // const SliverAppBar(
                //   leading: Padding(
                //     padding: EdgeInsets.only(left: 16),
                //     child: AppBarBackButton(),
                //   ),
                //   toolbarHeight: 100,
                //   backgroundColor: Colors.white,
                //   elevation: 0.3,
                //   title: Text('Title'),
                //   title: CollapsingAppBarTitle(
                //     child: Text(
                //       'Transaction history',
                //       style: Theme.of(context).appBarTheme.titleTextStyle,
                //     ),
                //   ),
                //   expandedHeight: 200,
                //   collapsedHeight: 100,
                // )
              ],
          body: _mainBody(context)),
    );
  }

  Widget _mainBody(BuildContext context) {
    List<Widget> children = [
      _descriptionRow(context),
      const SizedBox(
        height: 16,
      ),
      PlayerList(
        division: Division.mpo,
        event: widget.event,
      )
    ];
    // children.addAll(_eventStandings!.map(
    //     (eventPlayerData) => PlayerDataRow(eventPlayerData: eventPlayerData)));
    return Column(
      children: children,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            child: AutoSizeText(
              'NAME',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: MyPuttColors.darkGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
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
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/screens/events/event_detail/components/event_detail_panel.dart';
import 'package:myputt/screens/events/event_detail/components/player_list.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

import 'components/panels/update_division_panel.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Division division = Division.mpo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, _) => [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: AppBarBackButton(),
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  elevation: 0.3,
                  toolbarHeight: 48,
                  leadingWidth: 48,
                  expandedHeight: 250,
                  collapsedHeight: 56,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        EventDetailsPanel(
                          event: widget.event,
                          onDivisionUpdate: (Division updatedDivision) {
                            setState(() => division = updatedDivision);
                          },
                          division: division,
                        ),
                      ],
                    ),
                  ),
                  bottom: _changeDivisionButton(context),
                  title: CollapsingAppBarTitle(
                    child: Text(
                      'Summer Sizzler',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: MyPuttColors.darkGray),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                )
              ],
          body: _mainBody(context)),
    );
  }

  Widget _mainBody(BuildContext context) {
    return PlayerList(event: widget.event, division: division);
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
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
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              )),
          const SizedBox(width: 52),
        ],
      ),
    );
  }

  PreferredSizeWidget _changeDivisionButton(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
            child: Bounceable(
                onTap: () => displayBottomSheet(
                    context,
                    UpdateDivisionPanel(
                        currentDivision: division,
                        availableDivisions: widget.event.divisions,
                        onDivisionUpdate: (Division division) =>
                            setState(() => division = division))),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: MyPuttColors.darkBlue)),
                  child: Text(
                    division.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          const SizedBox(height: 8),
          _descriptionRow(context),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

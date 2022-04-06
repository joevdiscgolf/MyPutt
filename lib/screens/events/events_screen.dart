import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

import 'components/event_category_tab.dart';
import 'components/events_list.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  static String routeName = '/Events_screen';

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            floatingActionButton: _newEventButton(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            backgroundColor: MyPuttColors.white,
            appBar: AppBar(
              title: Text(
                'Events',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 40, color: MyPuttColors.blue),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            // floatingActionButton: _newEventButton(context),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            body: NestedScrollView(
              body: _mainBody(context),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [SliverToBoxAdapter(child: _tabBar(context))];
              },
            )));
  }

  Widget _mainBody(BuildContext context) {
    // state.activeEvents.sort(
    //     (c1, c2) => c1.creationTimeStamp.compareTo(c2.creationTimeStamp));
    // state.pendingEvents.sort(
    //     (c1, c2) => c1.creationTimeStamp.compareTo(c2.creationTimeStamp));
    // state.completedEvents.sort((c1, c2) {
    //   final int dateCompletedComparison = (c1.completionTimeStamp ?? 0)
    //       .compareTo(c2.completionTimeStamp ?? 0);
    //   return dateCompletedComparison != 0
    //       ? dateCompletedComparison
    //       : c1.creationTimeStamp.compareTo(c2.creationTimeStamp);
    // });
    return TabBarView(children: [
      EventsList(events: kTestEvents),
      Container(),

      // EventsList(
      //     category: EventCategory.pending,
      //     Events: List.from(state.pendingEvents.reversed)),
    ]);
  }

  Widget _tabBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: MyPuttColors.white, boxShadow: []),
      child: const TabBar(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: MyPuttColors.blue)),
        labelColor: MyPuttColors.blue,
        unselectedLabelColor: Colors.black,
        tabs: [
          EventCategoryTab(
            label: 'Club',
            icon: Icon(
              FlutterRemix.play_mini_line,
              size: 15,
            ),
          ),
          EventCategoryTab(
            label: 'Tournaments',
            icon: Icon(
              FlutterRemix.repeat_line,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _newEventButton(BuildContext context) {
    return Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyPuttButton(
            onPressed: () {},
            title: 'New Event',
            iconData: FlutterRemix.add_line,
            color: MyPuttColors.blue,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width / 2,
            shadowColor: MyPuttColors.gray[400],
          ),
        ));
  }
}

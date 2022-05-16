import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/collapsing_app_bar_title.dart';
import 'package:myputt/screens/events/tabs/search_tab.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

import 'components/event_category_tab.dart';
import 'components/events_list.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  static String routeName = '/Events_screen';

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;
  final TextEditingController _searchBarController = TextEditingController();
  String? _searchBarText;
  bool _showSearchBar = true;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() => _showSearchBar = _tabController.index == 0);
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: _newEventButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          bottom: _tabBar(context),
        ),
        // floatingActionButton: _newEventButton(context),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: NestedScrollView(
          body: _mainBody(context),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              // SliverAppBar(
              //   backgroundColor: MyPuttColors.white,
              //   title: CollapsingAppBarTitle(
              //     child: Text(
              //       'Events',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline6
              //           ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
              //     ),
              //   ),
              //   // floating: true,
              //   pinned: true,
              //   collapsedHeight: 80,
              //   expandedHeight: 200,
              //   flexibleSpace: FlexibleSpaceBar(
              //       centerTitle: true,
              //       title: Center(
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 24),
              //           child: Text(
              //             'Events',
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .headline6
              //                 ?.copyWith(
              //                     fontSize: 24, color: MyPuttColors.blue),
              //           ),
              //         ),
              //       )),
              //   shadowColor: Colors.transparent,
              //   bottom: _sliverBarBottom(context),
              // ),
              // SliverToBoxAdapter(child: _tabBar(context)),
              // if (_tabController.index == 0)
              //   SliverToBoxAdapter(
              //     child: _searchBar(context),
              //   )
            ];
          },
        ));
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
    return TabBarView(controller: _tabController, children: [
      EventsList(events: kTestEvents),
      // SearchTab(),
      Container(),
      EventsList(events: kTestEvents),
      // EventsList(
      //     category: EventCategory.pending,
      //     Events: List.from(state.pendingEvents.reversed)),
    ]);
  }

  PreferredSizeWidget _sliverBarBottom(BuildContext context) {
    return PreferredSize(
        child: Column(
          children: [_tabBar(context), if (_showSearchBar) _searchBar(context)],
        ),
        preferredSize: Size.fromHeight(_showSearchBar ? 80 : 80));
  }

  PreferredSizeWidget _tabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: MyPuttColors.white,
        child: TabBar(
          controller: _tabController,
          indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: MyPuttColors.blue)),
          labelColor: MyPuttColors.blue,
          unselectedLabelColor: Colors.black,
          tabs: const [
            EventCategoryTab(
                label: 'Search',
                icon: Icon(
                  FlutterRemix.search_line,
                  size: 16,
                )),
            EventCategoryTab(
              label: 'Club',
              icon: Icon(FlutterRemix.group_fill, size: 16),
            ),
            EventCategoryTab(
              label: 'Tournaments',
              icon: Icon(FlutterRemix.trophy_fill, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: _searchBarController,
        autocorrect: false,
        maxLines: 1,
        maxLength: 24,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Event name',
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
        onChanged: (String text) => setState(() => _searchBarText = text),
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

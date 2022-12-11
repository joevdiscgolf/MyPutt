import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/navigation/animated_route.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/components/event_search_loading_screen.dart';
import 'package:myputt/screens/events/event_detail/event_detail_screen.dart';
import 'package:myputt/screens/events/tabs/my_events_tab.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

import 'components/event_category_tab.dart';
import 'components/events_list.dart';
import 'create_event/create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  static String routeName = '/events_screen';

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final EventsService _eventsService = locator.get<EventsService>();

  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;
  final TextEditingController _searchBarController = TextEditingController();
  String? _searchBarText;
  bool _showSearchBar = true;
  bool _loading = false;
  List<MyPuttEvent>? _events;
  bool _searchError = false;

  Timer? _searchOnStoppedTyping;

  Future<void> _searchEvents(String keyword) async {
    setState(() {
      _searchError = false;
      _loading = true;
    });
    try {
      await _eventsService.searchEvents(keyword).then((response) => setState(
            () {
              _loading = false;
              _events = response.events;
            },
          ));
    } catch (e) {
      setState(() {
        _loading = false;
        _searchError = true;
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this)
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
        toolbarHeight: _showSearchBar ? 100 : 60,
        title: Text(
          'Events',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 24, color: MyPuttColors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        bottom: _appBarBottom(context),
        elevation: 0.5,
      ),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        _searchTab(context),
        EventsList(
          events: kTestEvents,
          onPressed: (MyPuttEvent event) => _openEvent(event),
        ),
        EventsList(
          events: kTestEvents,
          onPressed: (MyPuttEvent event) => _openEvent(event),
        ),
        const MyEventsTab(),
      ],
    );
  }

  PreferredSizeWidget _appBarBottom(BuildContext context) {
    return PreferredSize(
        child: Column(
          children: [
            _tabBar(context),
            if (_showSearchBar) ...[
              const SizedBox(height: 4),
              _searchBar(context)
            ]
          ],
        ),
        preferredSize: Size.fromHeight(_showSearchBar ? 80 : 60));
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
              ),
            ),
            EventCategoryTab(
              label: 'Club',
              icon: Icon(FlutterRemix.group_fill, size: 16),
            ),
            EventCategoryTab(
              label: 'Tournaments',
              icon: Icon(FlutterRemix.trophy_fill, size: 16),
            ),
            EventCategoryTab(label: 'My Events', icon: blueFrisbeeImageIcon),
          ],
        ),
      ),
    );
  }

  Widget _searchTab(BuildContext context) {
    if (_searchError) {
      return EmptyState(
        title: 'Network error',
        subtitle: "Please try again.",
        onRetry: () {
          if (_searchBarText != null && _searchBarText!.isNotEmpty) {
            _searchEvents(_searchBarText!);
          }
        },
      );
    } else if (_loading) {
      return const EventSearchLoadingScreen();
    } else if (_searchBarText == null || _searchBarText?.isEmpty == true) {
      return Container();
    } else if (_events?.isNotEmpty != true || _events == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Center(
          child: Column(
            children: [
              const Icon(FlutterRemix.stack_line, size: 40),
              const SizedBox(height: 16),
              Text(
                "We couldn't find any events matching your search.",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: MyPuttColors.darkGray),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }

    // if loaded
    return EventsList(
      events: _events!,
      onPressed: (MyPuttEvent event) => _openEvent(event),
      onRefresh: () {
        if (_searchBarText != null && _searchBarText!.isNotEmpty) {
          _searchEvents(_searchBarText!);
        }
      },
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: _searchBarController,
        autocorrect: false,
        maxLines: 1,
        maxLength: 24,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Search by name or code',
          contentPadding:
              const EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
          isDense: true,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: MyPuttColors.gray[300], fontSize: 18),
          enabledBorder: Theme.of(context)
              .inputDecorationTheme
              .border
              ?.copyWith(
                  borderSide: const BorderSide(color: MyPuttColors.gray)),
          focusedBorder: Theme.of(context)
              .inputDecorationTheme
              .border
              ?.copyWith(
                  borderSide: const BorderSide(color: MyPuttColors.gray)),
          suffixIcon: const Icon(
            FlutterRemix.search_line,
            color: MyPuttColors.darkGray,
          ),
          errorBorder: InputBorder.none,
          counter: const Offstage(),
        ),
        onChanged: (String text) => _searchHandler(text),
      ),
    );
  }

  Widget _newEventButton(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
      },
      child: MyPuttButton(
        onPressed: () {
          BlocProvider.of<EventsCubit>(context).createEventPressed();
          Navigator.of(context)
              .push(AnimatedRoute(const CreateEventScreen()))
              .then((_) {
            if (BlocProvider.of<EventsCubit>(context).newEventWasCreated) {
              setState(() => _tabController.index = 3);
            }
          });
        },
        title: 'New Event',
        iconData: FlutterRemix.add_line,
        backgroundColor: MyPuttColors.blue,
        textSize: 16,
        width: MediaQuery.of(context).size.width / 2,
        shadowColor: MyPuttColors.gray[400],
      ),
    );
  }

  void _searchHandler(String? value) {
    setState(() {
      _searchBarText = value;
      _loading = _searchBarText?.isNotEmpty == true;
    });

    if (_searchOnStoppedTyping != null) {
      setState(() => _searchOnStoppedTyping?.cancel());
    }
    setState(
      () => _searchOnStoppedTyping = Timer(
        const Duration(milliseconds: 250),
        () {
          if (value != null && value.isNotEmpty) {
            _searchEvents(value);
          }
        },
      ),
    );
  }

  void _openEvent(MyPuttEvent event) {
    BlocProvider.of<EventsCubit>(context).openEvent(event);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }
}

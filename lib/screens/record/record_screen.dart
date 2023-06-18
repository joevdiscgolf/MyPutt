import 'package:flutter/material.dart';
import 'package:myputt/screens/record/components/record_screen_app_bar.dart';
import 'package:myputt/screens/record/tabs/record_tab/record_tab.dart';
import 'package:myputt/screens/record/tabs/sets_tab/sets_tab.dart';
import 'package:myputt/utils/colors.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: RecordScreenAppBar(
        tabController: _tabController,
        topViewPadding: MediaQuery.of(context).viewPadding.top,
      ),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: const [
        RecordTab(),
        SetsTab(),
      ],
    );
  }
}

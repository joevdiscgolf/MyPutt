import 'dart:async';

class NavigationService {
  NavigationService() {
    mainWrapperTabStream = _mainWrapperTabController.stream.asBroadcastStream();
  }
  final StreamController<int> _mainWrapperTabController = StreamController();
  late final Stream<int> mainWrapperTabStream;

  void setMainWrapperTab(int index) {
    _mainWrapperTabController.add(index);
  }
}

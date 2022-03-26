import 'dart:async';

import 'package:myputt/utils/enums.dart';

class ScreenController {
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> appStateStream;
  ScreenController() {
    controller = StreamController<AppScreenState>();
    appStateStream = controller.stream;
  }
}

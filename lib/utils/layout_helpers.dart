import 'package:flutter/widgets.dart';

bool hasTopPadding(BuildContext context) =>
    MediaQuery.of(context).viewPadding.top > 0;

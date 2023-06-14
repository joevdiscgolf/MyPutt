import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/utils/icons/myputt_icons.dart';

const Map<PuttingStance, String> puttingStanceToNameMap = {
  PuttingStance.staggered: 'Staggered',
  PuttingStance.straddle: 'Straddle',
};

const Map<PuttingStance, String> puttingStanceToAssetPathMap = {
  PuttingStance.staggered: MyPuttIcons.staggeredPuttIcon,
  PuttingStance.straddle: MyPuttIcons.straddlePuttIcon,
};

const Map<PuttingStance, String> puttingStanceToSubtitleMap = {
  PuttingStance.staggered: 'Mcmahon, Mcbeth, Wysocki',
  PuttingStance.straddle: 'KJ, Sexton, Tamm',
};

const Map<WindDirection, String> windDirectionToNameMap = {
  WindDirection.headwind: 'Headwind',
  WindDirection.tailwind: 'Tailwind',
  WindDirection.ltrCross: 'Left-to-right',
  WindDirection.rtlCross: 'Right-to-left',
};

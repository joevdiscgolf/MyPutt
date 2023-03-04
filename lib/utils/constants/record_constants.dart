import 'package:myputt/models/data/conditions/condition_enums.dart';

const Map<PuttingStance, String> puttingStanceToNameMap = {
  PuttingStance.staggered: 'Staggered',
  PuttingStance.straddle: 'Straddle',
  PuttingStance.knee: 'Knee',
};

const Map<PuttingStance, String> puttingStanceToSubtitleMap = {
  PuttingStance.staggered: 'Mcmahon, Mcbeth, Wysocki',
  PuttingStance.straddle: 'KJ, Sexton, Tamm',
  PuttingStance.knee: 'Some weirdo',
};

const Map<WindDirection, String> windDirectionToNameMap = {
  WindDirection.headwind: 'Headwind',
  WindDirection.tailwind: 'Tailwind',
  WindDirection.ltrCross: 'Left-to-right',
  WindDirection.rtlCross: 'Right-to-left',
};

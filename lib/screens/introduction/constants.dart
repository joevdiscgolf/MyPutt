import 'components/carousel_item.dart';

const List<CarouselItem> kCarouselItems = [
  CarouselItem(
    assetPath: kSessionsScreenScreenshotSrc,
    title: 'Take your putting to the next level',
    limitWidth: true,
    subtitle: "Record your putting sessions from anywhere in a few taps",
  ),
  CarouselItem(
    assetPath: kChallengeRecordScreenshotSrc,
    title: 'Challenge your friends',
    limitWidth: true,
    subtitle: 'Compete head-to-head or when you have time',
  ),
  CarouselItem(
    assetPath: kHomeScreenScreenshotSrc,
    title: 'Track your progress',
    subtitle: 'Watch your practice pay off',
  ),
  CarouselItem(
      title: 'View lifetime stats',
      subtitle: 'View your stats for challenges and sessions',
      assetPath: kLifetimeStatsScreenshotsSrc)
];

const String kLifetimeStatsScreenshotsSrc =
    'assets/introduction_screen/lifetime_stats_sim_screenshot.png';
const String kSessionsScreenScreenshotSrc =
    'assets/introduction_screen/session_screen_cutout.png';
const String kChallengeRecordScreenshotSrc =
    'assets/introduction_screen/challenge_record_screenshot.png';
const String kHomeScreenScreenshotSrc =
    'assets/introduction_screen/home_screen_cutout.png';

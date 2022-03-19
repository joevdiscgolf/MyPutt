import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

final List<PageViewModel> kIntroPages = [
  PageViewModel(
      title: 'Take your putting to the next level',
      body: "Record your putting sessions from anywhere with a few taps.",
      image: const Image(
        image: AssetImage(kSessionsScreenScreenshot),
      )),
  PageViewModel(
      title: 'Challenge your friends',
      body: 'Compete head-to-head or when you have time.',
      image: const Image(
        image: AssetImage(kChallengeRecordScreenshot),
      )),
  PageViewModel(
    title: 'Track your progress',
    image: const Image(
      image: AssetImage(kHomeScreenScreenshot),
    ),
    body: 'Watch your practice pay off over time',
  ),
  PageViewModel(
    title: 'View lifetime stats',
    body: 'View detailed stats for challenges and practice sessions.',
    image: const Image(
      image: AssetImage(kLifetimeStatsScreenshots),
    ),
  ),
];

const String kLifetimeStatsScreenshots =
    'assets/introduction_screen/lifetime_stats_sim_screenshot.png';
const String kSessionsScreenScreenshot =
    'assets/introduction_screen/session_screen_cutout.png';
const String kChallengeRecordScreenshot =
    'assets/introduction_screen/challenge_record_screenshot.png';
const String kHomeScreenScreenshot =
    'assets/introduction_screen/home_screen_cutout.png';

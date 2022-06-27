import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/locator.dart';

class DynamicLinkService {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  Future<Uri> generateDynamicLinkFromId(String challengeId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(
            'https://www.myputt.com/challenge?challengeId=$challengeId'),
        uriPrefix: 'https://myputt.page.link',
        iosParameters: const IOSParameters(
            bundleId: 'com.joevdiscgolf.myputt', minimumVersion: '1'),
        androidParameters:
            const AndroidParameters(packageName: 'com.joevdiscgolf.myputt'));
    return FirebaseDynamicLinks.instance.buildLink(parameters);
  }

  Future handleDynamicLinks() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      log('onLink error: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      final String challengeId =
          deepLink.toString().split('/').last.split('=').last;
      final StoragePuttingChallenge? challenge =
          await _databaseService.retrieveUnclaimedChallenge(challengeId);
      if (challenge != null &&
          !listContainsChallenge(
              _challengesRepository.deepLinkChallenges, challenge)) {
        _challengesRepository.deepLinkChallenges.add(challenge);
        _challengesRepository.addDeepLinkChallenges();
      }
    }
  }

  bool listContainsChallenge(List<StoragePuttingChallenge> challenges,
      StoragePuttingChallenge specifiedChallenge) {
    for (var challenge in challenges) {
      if (challenge.id == specifiedChallenge.id) {
        return true;
      }
    }
    return false;
  }
}

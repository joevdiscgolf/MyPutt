import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/screens/challenge/challenge_record_screen.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/locator.dart';

class DynamicLinkService {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final AuthService _authService = locator.get<AuthService>();
  Future<Uri> generateDynamicLinkFromId(String challengeId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(
            'https://www.myputt.com/challenge?challengeId=$challengeId'),
        uriPrefix: 'https://myputt.page.link',
        iosParameters: const IOSParameters(
            bundleId: 'com.joev.myputtapp', minimumVersion: '1'));
    return FirebaseDynamicLinks.instance.buildLink(parameters);
  }

  Future handleDynamicLinks() async {
    /*final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(
            'https://www.myputt.com/challenge?challengeId=ThisIsATest'),
        uriPrefix: 'https://myputt.page.link',
        iosParameters: const IOSParameters(
            bundleId: 'com.joev.myputtapp', minimumVersion: '1'));
    print(await FirebaseDynamicLinks.instance.buildLink(parameters));*/

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print('initial link');
      _handleDeepLink(initialLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      print('onLink error: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deepLink: $deepLink');
      final String challengeId =
          deepLink.toString().split('/').last.split('=').last;
      print('_handleDeepLink | challengeId: $challengeId');
      final StoragePuttingChallenge? challenge =
          await _databaseService.retrieveUnclaimedChallenge(challengeId);
      if (challenge != null) {
        _challengesRepository.deepLinkChallenges.add(challenge);
        if (_authService.getCurrentUserId() != null) {
          _challengesRepository.addDeepLinkChallenges();
        }
        print('Added: ${challenge.toJson()}');
      }
    }
  }
}

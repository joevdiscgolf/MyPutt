import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<Uri> generateDynamicLinkFromId(String challengeId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(
            'https://www.myputt.com/challenge?challengeId=$challengeId'),
        uriPrefix: 'https://myputt.page.link/acceptChallenge',
        iosParameters: const IOSParameters(
            bundleId: 'com.joev.myputtapp', minimumVersion: '1'));
    return FirebaseDynamicLinks.instance.buildLink(parameters);
  }

  Future handleDynamicLinks() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(
            'https://www.myputt.com/challenge?challengeId=testChallenge}'),
        uriPrefix: 'https://myputt.page.link/acceptChallenge',
        iosParameters: const IOSParameters(
            bundleId: 'com.joev.myputtapp', minimumVersion: '1'));
    print(await FirebaseDynamicLinks.instance.buildLink(parameters));

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink
        .listen((dynamicLinkData) {})
        .onError((error) {
      print('onLink error: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    print('handling deep link');
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deepLink: $deepLink');
    }
  }
}

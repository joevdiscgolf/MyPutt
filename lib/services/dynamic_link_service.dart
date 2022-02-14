import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      print('onLink error: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deepLink: $deepLink');
    }
  }
}

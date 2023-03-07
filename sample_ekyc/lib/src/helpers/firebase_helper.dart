import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {
  Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future handleDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('DAN Deep link found: $deepLink');
    }

    // INTO FOREGROUND FROM DYNAMIC LINK LOGIC

    Stream<PendingDynamicLinkData> linkStream =
        FirebaseDynamicLinks.instance.onLink;
    linkStream.listen((PendingDynamicLinkData? data) async {
      final Uri? deepLink = data?.link;
      if (deepLink != null) {
        print('DAN Deep link found: $deepLink');
      }
    });
  }
}
